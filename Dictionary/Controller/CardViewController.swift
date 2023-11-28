//
//  CardViewController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 27.11.2023.
//

import UIKit

class CardViewController: UIViewController {
    
    let cardView = CardView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(cardView)
        cardView.fillSuperview()
    }
    
    @objc func didTapShowAnswerButton() {
        print("you did push show answers")
    }
    
    @objc func didTapButtonStack() {
        print("you did push buttonStack button")
    }
    
}
