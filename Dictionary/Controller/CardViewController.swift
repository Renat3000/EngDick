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
    private var currentNumberInArray = 0
    fileprivate var JSONTopResult = [JSONStruct]() {
        didSet {
            cardView.setDefinitionLabelText(newText: JSONTopResult[0].meanings[0].definitions[0].definition)
        }
    }
    
    func buttonPressed(withTitle title: String) {
        let count = models.count
        
        switch title {
            case "Show Answer":
            fillDefinitionLabel()
            case "Easy":
               guard currentNumberInArray < count-1 else {
                   currentNumberInArray = 0
                   if let word = models[currentNumberInArray].word {
                       cardView.setWordLabelText(newText: word)
                   }
                   return
               }
            
            currentNumberInArray += 1
               if let word = models[currentNumberInArray].word {
                   cardView.setWordLabelText(newText: word)
                   cardView.definitionLabel.text = ""
               }
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
        
        if let word = models[currentNumberInArray].word {
            cardView.setWordLabelText(newText: word)
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
        if let word = models[currentNumberInArray].word {
            fetchDictionary(searchTerm: word)
        }
    }
    
}
