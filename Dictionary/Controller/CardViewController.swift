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
    private var newArray = [FavoritesItem]()
    // add exceptions
    private var newArrayIsEmpty = true
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
        
        if newArray.count != 0 {
            newArrayIsEmpty = false
            newArray = checkItemsForToday(models: models)
            if let word = newArray[currentNumberInArray].word {
                cardView.setWordLabelText(newText: word)
            }
            cardView.setButtonsActive(active: true)
        } else {
//            cardView.setWordLabelText(newText: "NO WORDS")
//            cardView.setButtonsActive(active: false)
            if let word = models[currentNumberInArray].word {
                cardView.setWordLabelText(newText: word)
            }
        }
        
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
    
    func fillDefinitionLabel() {
        if let word = newArray[currentNumberInArray].word {
            fetchDictionary(searchTerm: word)
        }
    }
    
    func answerButtonPushed(Name: String) {
        
        let count = (newArrayIsEmpty == true) ? models.count : newArray.count
        let item = (newArrayIsEmpty == true) ? models[currentNumberInArray] : newArray[currentNumberInArray]
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
        case "Again": qualityOfAnswer = 0
        default: break
        }
        
        let numberOfRepetitions = item.numberrOfRepetitions
        let newNumberOfRepetitions = numberOfRepetitions + 1.0
        
        let newEasinessFactor = calculateEasiness(qualityOfAnswer: qualityOfAnswer, easinessFactor: item.easinessFactor)
        coreDataService.updateItem(item: item, newNumberOfRepetitions: newNumberOfRepetitions, newEasinessFactor: newEasinessFactor)
        
        // probably need to check it twice... quite hard to understand
        let newInterepetitionInterval = interepetitionInterval(numberOfRepetitions: newNumberOfRepetitions, easinessFactor: item.easinessFactor, previousInterval: item.latestInterval)
        coreDataService.updateItemInterval(item: item, newInterval: newInterepetitionInterval)
        
        currentNumberInArray += 1
        
        if currentNumberInArray == count {
            currentNumberInArray = 0
        }
        
        if newArrayIsEmpty {
            if let word = models[currentNumberInArray].word {
                cardView.setWordLabelText(newText: word)
            }
        }
        
        if !newArrayIsEmpty {
            if let word = newArray[currentNumberInArray].word {
                cardView.setWordLabelText(newText: word)
                
            }
        }
        cardView.definitionLabel.text = ""
        print(item.easinessFactor)
        print(item.numberrOfRepetitions)
        
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
        
        print(round(interval))
        return round(interval)  // we need to round it up
    }
    
    func checkItemsForToday(models: [FavoritesItem]) -> [FavoritesItem] {
        var currentArray = [FavoritesItem]()

        for i in models {
    
            if let lastReviewDate = i.dateOfLastReview {
                let targetDate = Calendar.current.date(byAdding: .day, value: Int(i.latestInterval), to: lastReviewDate) ?? Date()

                let currentDate = Date()

                // compare todays date with target date
                if currentDate <= targetDate {
                    currentArray.append(i)
                }
            } else {
                print("There's no dateOfLastReview")
            }

        }
        print(currentArray)
        return currentArray
    }
}
