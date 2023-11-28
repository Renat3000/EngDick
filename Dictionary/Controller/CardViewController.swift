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

    func buttonPressed(withTitle title: String) {
        let count = models.count
           guard currentNumberInArray < count else {
               currentNumberInArray = 0
               return
           }

           if let word = models[currentNumberInArray].word {
               cardView.setLabelText(newText: word)
               currentNumberInArray += 1
           }
    }
    
    private lazy var cardView: CardView = {
        let view = CardView()
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(cardView)
        cardView.fillSuperview()
    }
    
}
