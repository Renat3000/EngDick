//
//  CardViewController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 27.11.2023.
//

import UIKit

class CardViewController: UIViewController, CardViewDelegate {
    
    let coreDataService = CoreDataService.shared
    private var models = CoreDataService.shared.getAllItems()
    private var arrayForToday = [FavoritesItem]()
    private let calendar = Calendar.current
    
    private var currentNumberInArray = 0
    
    private lazy var cardView: CardView = {
        let view = CardView()
        view.delegate = self
        return view
    }()
    
    deinit {
        print("os reclaiming memory for CardViewController - no retain cycles / leaks")
    }
    func buttonPressed(withTitle title: String) {
        
        switch title {
        case "Show Answer":
            fillDefinitionLabel()
        case "Easy":
            answerButtonPushed(Name: "Easy")
        case "Good":
            answerButtonPushed(Name: "Good")
        case "Hard":
            answerButtonPushed(Name: "Hard")
        case "Again":
            answerButtonPushed(Name: "Again")
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupArrays()
        view.addSubview(cardView)
        cardView.fillSuperview()
    }
    
    func setupArrays() {
        arrayForToday = checkItemsForToday(models: models)
        
        if !arrayForToday.isEmpty {
            if let word = arrayForToday[currentNumberInArray].word {
                cardView.setWordLabelText(newText: word)
            }
            cardView.setButtonsActive(active: true)
        } else {
            setButtonsInactive()
        }
        
        cardView.setCardsNumbers(cardsForToday: arrayForToday.count, cardsTotal: models.count)
//        print("print at the start of app", arrayForToday)
        var joinedArray = [String]()
        arrayForToday.forEach{
            if let w = $0.word {
                joinedArray.append(w)
            }
        }
        print("array for today at the startup is:", joinedArray)
    }
    
    func fillDefinitionLabel() {
        if let definition = arrayForToday[currentNumberInArray].definition {
            cardView.definitionLabel.attributedText = definition
        } else {
            cardView.definitionLabel.text = ""
        }
    }
    
    func checkItemsForToday(models: [FavoritesItem]) -> [FavoritesItem] {
        var currentArray = [FavoritesItem]()

        for i in models {
            if let targetDate = i.targetDate {

                let target = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: targetDate)) ?? Date()
                let currentDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: Date())) ?? Date()
                
                // comparing the dates
                if target <= currentDate {
                    currentArray.append(i)
                }
            }
        }
        currentArray.shuffle()
//        print(currentArray)
        return currentArray
    }
    
    func answerButtonPushed(Name: String) {
        cardView.definitionLabel.text = ""
        let count = (arrayForToday.isEmpty == true) ? models.count : arrayForToday.count
        let item = (arrayForToday.isEmpty == true) ? models[currentNumberInArray] : arrayForToday[currentNumberInArray]
        var qualityOfAnswer = 0
        
//        After each repetition assess the quality of repetition response in 0-5 grade scale:
//        5 – perfect response
//        4 – correct response after a hesitation
//        3 – correct response recalled with serious difficulty
//        2 – incorrect response; where the correct one seemed easy to recall
//        1 – incorrect response; the correct one remembered
//        0 – complete blackout.
        
        switch Name {
        case "Easy": qualityOfAnswer = 5
        case "Good": qualityOfAnswer = 4
        case "Hard": qualityOfAnswer = 2
            coreDataService.updateItemNumberOfRepetitions(item: item, newNumber: 1.0)
        case "Again": qualityOfAnswer = 0
            coreDataService.updateItemNumberOfRepetitions(item: item, newNumber: 0.0)
        default: break
        }
        
        let numberOfRepetitions = item.numberrOfRepetitions
        let newNumberOfRepetitions = numberOfRepetitions + 1.0
        let newEasinessFactor = calculateEasiness(qualityOfAnswer: qualityOfAnswer, easinessFactor: item.easinessFactor)
        let newInterepetitionInterval = interepetitionInterval(numberOfRepetitions: newNumberOfRepetitions, easinessFactor: item.easinessFactor, previousInterval: item.latestInterval)
        
        coreDataService.updateItemInterval(item: item, newInterval: newInterepetitionInterval)
        
        let currentDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: Date())) ?? Date()
        
        if let lastReviewDate = item.dateOfLastReview {
            
            //need to add function to randomize deck, or take the latest reviewed card to the back of the deck after pressing easy. because sometimes you press easy button and it shows the words again...
            
            let targetDateComponents = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: Int(item.latestInterval), to: Date()) ?? Date())
            let targetDate = calendar.date(from: targetDateComponents) ?? Date()
            
            switch Name {
            case "Easy":
                print("before button is pressed, word is", item.word ?? "no value if absent", "number of repetitions", item.numberrOfRepetitions, "EF = ", item.easinessFactor, "date of last review = ", item.dateOfLastReview ?? "no value if absent", "target date = ", item.targetDate ?? "no value if absent", "latestInterval is",  item.latestInterval)
                coreDataService.updateItem(item: item, newNumberOfRepetitions: newNumberOfRepetitions, newEasinessFactor: newEasinessFactor, newDateOfReview: Date(), targetDate: targetDate)
                print("after, word is", item.word ?? "no value if absent", "new number of repetitions", item.numberrOfRepetitions, "new EF = ", item.easinessFactor, "new date of last review = ", item.dateOfLastReview ?? "no value if absent", "new target date = ", item.targetDate ?? "no value if absent", "latestInterval is",  item.latestInterval)
                arrayForToday = checkItemsForToday(models: models)
                currentNumberInArray = 0
//                print(arrayForToday[currentNumberInArray].targetDate)
//                arrayForToday.remove(at: currentNumberInArray)
//                  still have to press EASY button 2 times even on the old cards...
            case "Good":
                coreDataService.updateItem(item: item, newNumberOfRepetitions: newNumberOfRepetitions, newEasinessFactor: newEasinessFactor, newDateOfReview: Date(), targetDate: targetDate)
                currentNumberInArray += 1
            case "Hard":
                coreDataService.updateItem(item: item, newNumberOfRepetitions: newNumberOfRepetitions, newEasinessFactor: newEasinessFactor, newDateOfReview: lastReviewDate, targetDate: currentDate)
                currentNumberInArray += 1
            case "Again":
                coreDataService.updateItem(item: item, newNumberOfRepetitions: newNumberOfRepetitions, newEasinessFactor: newEasinessFactor, newDateOfReview: lastReviewDate, targetDate: currentDate)
                currentNumberInArray += 1
            default: break
            }
        }
        
        cardView.setCardsNumbers(cardsForToday: arrayForToday.count, cardsTotal: models.count)
        if currentNumberInArray == count {
            currentNumberInArray = 0
        }
        
        if !arrayForToday.isEmpty {
//            print(arrayForToday)
            var joinedArrayCheck = [String]()
            arrayForToday.forEach{
                if let w = $0.word {
                    joinedArrayCheck.append(w)
                }
            }
            print("array for today:", joinedArrayCheck)
            print("array for today count is", arrayForToday.count)
            print("current Number In Array is", currentNumberInArray)
            
            if let word = arrayForToday[currentNumberInArray].word {
                cardView.setWordLabelText(newText: word)
            }
        } else {
            setButtonsInactive()
        }

//        print("word", item.word)
//        print("item.easinessFactor is", item.easinessFactor)
//        print("item.numberrOfRepetitions is", item.numberrOfRepetitions)
    }
    
  // MARK: calculcations of EF and I(n) below
    func calculateEasiness(qualityOfAnswer: Int, easinessFactor: Double) -> Double {
        
//        EF’:=EF+(0.1-(5-q)*(0.08+(5-q)*0.02)), where:
//        EF’ – new value of the E-Factor,
//        EF – old value of the E-Factor,
//        q – quality of the response in the 0-5 grade scale.
//        If EF is less than 1.3 then let EF be 1.3.
        
        let intermediateValue: Double = Double(5) - Double(qualityOfAnswer)
        let formula: Double = 0.1 - intermediateValue * (0.08 + intermediateValue * 0.02)
        var newEasinessFactor = easinessFactor + formula
        if newEasinessFactor < 1.3 {
            newEasinessFactor = 1.3
        }
        
        return newEasinessFactor
    }
    
    func interepetitionInterval(numberOfRepetitions: Double, easinessFactor: Double, previousInterval: Double) -> Double {
        
//        Repeat items using the following intervals:
//        I(1):=1
//        I(2):=6
//        for n>2: I(n):=I(n-1)*EF
//        where:
//        I(n) – inter-repetition interval after the n-th repetition (in days),
//        EF – E-Factor of a given item
//        If interval is a fraction, round it up to the nearest integer.
        
        var interval = Double()
        
        switch numberOfRepetitions {
        case 1.0:
            interval = 1
        case 2.0:
            interval = 1
        default:
            interval = previousInterval * easinessFactor
        }
        
//        print("rounded interval of repetitions", round(interval))
        return round(interval)  // we need to round it up
    }
    
// MARK: misk functions
    func setButtonsInactive() {
        cardView.setButtonsActive(active: false)
        cardView.setWordLabelText(newText: "No words for review today!")
        cardView.definitionLabel.text = ""
    }
}
