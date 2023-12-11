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
    
    private var currentNumberInArray = 0
    fileprivate var JSONTopResult = [JSONStruct]() {
        didSet {
            cardView.setDefinitionLabelText(newText: JSONTopResult[0].meanings[0].definitions[0].definition)
        }
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
    
    private lazy var cardView: CardView = {
        let view = CardView()
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupArrays()
        view.addSubview(cardView)
        cardView.fillSuperview()
    }
    
    fileprivate func fetchDictionary(searchTerm: String) {
        //get back json-fetched data from the JSONService file
        print("firing off request, just wait!")
        JSONService.shared.fetchJSON(searchTerm: searchTerm) { (JSONStruct, err)  in
            
            if let err = err {
                print("failed to fetch dictionary entries", err)
                return
            }
            DispatchQueue.main.async {
                self.JSONTopResult = JSONStruct
            }
        }
    }
    
    func setupArrays() {
        arrayForToday = checkItemsForToday(models: models)
        
        if !arrayForToday.isEmpty {
            if let word = arrayForToday[currentNumberInArray].word {
                cardView.setWordLabelText(newText: word)
            }
            cardView.setButtonsActive(active: true)
        }
    }
    
    func fillDefinitionLabel() {
        if let word = arrayForToday[currentNumberInArray].word {
            fetchDictionary(searchTerm: word)
        }
    }
    
    func answerButtonPushed(Name: String) {
        
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
            arrayForToday.remove(at: currentNumberInArray)
        case "Good": qualityOfAnswer = 4
            arrayForToday.remove(at: currentNumberInArray)
        case "Hard": qualityOfAnswer = 2
            coreDataService.updateItemNumberOfRepetitions(item: item, newNumber: 1.0)
        case "Again": qualityOfAnswer = 0
            coreDataService.updateItemNumberOfRepetitions(item: item, newNumber: 0.0)
        default: break
        }
        
        if arrayForToday.isEmpty {
            cardView.setButtonsActive(active: false)
            cardView.setWordLabelText(newText: "No words for review today!")
            cardView.definitionLabel.text = ""
        }
        
        let numberOfRepetitions = item.numberrOfRepetitions
        let newNumberOfRepetitions = numberOfRepetitions + 1.0
        
        let newEasinessFactor = calculateEasiness(qualityOfAnswer: qualityOfAnswer, easinessFactor: item.easinessFactor)
        
        let calendar = Calendar.current
        let currentDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: Date())) ?? Date()
        
        if let lastReviewDate = item.dateOfLastReview {
            
            let targetDateComponents = calendar.dateComponents([.year, .month, .day], from: calendar.date(byAdding: .day, value: Int(item.latestInterval), to: lastReviewDate) ?? Date())
            let targetDate = calendar.date(from: targetDateComponents) ?? Date()
            
            switch Name {
            case "Easy":
                coreDataService.updateItem(item: item, newNumberOfRepetitions: newNumberOfRepetitions, newEasinessFactor: newEasinessFactor, newDateOfReview: Date(), targetDate: targetDate)
            case "Good":
                coreDataService.updateItem(item: item, newNumberOfRepetitions: newNumberOfRepetitions, newEasinessFactor: newEasinessFactor, newDateOfReview: Date(), targetDate: targetDate)
            case "Hard":
                coreDataService.updateItem(item: item, newNumberOfRepetitions: newNumberOfRepetitions, newEasinessFactor: newEasinessFactor, newDateOfReview: lastReviewDate, targetDate: currentDate)
            case "Again":
                coreDataService.updateItem(item: item, newNumberOfRepetitions: newNumberOfRepetitions, newEasinessFactor: newEasinessFactor, newDateOfReview: lastReviewDate, targetDate: currentDate)
            default: break
            }
        }
        
        // probably need to check it twice... quite hard to understand
        let newInterepetitionInterval = interepetitionInterval(numberOfRepetitions: newNumberOfRepetitions, easinessFactor: item.easinessFactor, previousInterval: item.latestInterval)
        coreDataService.updateItemInterval(item: item, newInterval: newInterepetitionInterval)
        
        currentNumberInArray += 1
        
        if currentNumberInArray == count {
            currentNumberInArray = 0
        }
        
        if arrayForToday.isEmpty {
            if let word = models[currentNumberInArray].word {
                cardView.setWordLabelText(newText: word)
            }
        }
        
        if !arrayForToday.isEmpty {
            if let word = arrayForToday[currentNumberInArray].word {
                cardView.setWordLabelText(newText: word)
                
            }
        }
        cardView.definitionLabel.text = ""
        print("word", item.word)
        print("item.easinessFactor is", item.easinessFactor)
        print("item.numberrOfRepetitions is", item.numberrOfRepetitions)
        
    }
    
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
        
        print("rounded interval of repetitions", round(interval))
        return round(interval)  // we need to round it up
    }
    
    func checkItemsForToday(models: [FavoritesItem]) -> [FavoritesItem] {
        var currentArray = [FavoritesItem]()

        for i in models {
            if let targetDate = i.targetDate {
                let calendar = Calendar.current

                let target = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: targetDate)) ?? Date()
                let currentDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: Date())) ?? Date()
                
                // comparing the dates
                if target <= currentDate {
                    currentArray.append(i)
                }
            } else {
                print("There's no dateOfLastReview")
            }
        }

        if currentArray.count == 0 {
            cardView.setButtonsActive(active: false)
            cardView.setWordLabelText(newText: "No words for review today!")
        }
        
        return currentArray
    }
}
