//
//  CardView.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 28.11.2023.
//

import UIKit

class CardView: UIView {

    weak var delegate: CardViewDelegate?
    
    let wordStackViewVertical = makeStackView()
    let wordLabel = makeLabel()
    let definitionLabel = makeLabel()
    let showAnswerButton = makeButtonForSets(withText: "Show Answer")
    let easyButton = makeButtonForSets(withText: "Easy")
    let goodButton = makeButtonForSets(withText: "Good")
    let hardButton =  makeButtonForSets(withText: "Hard")
    let againButton = makeButtonForSets(withText: "Again")
    let buttonStackView = makeStackView()
    
    let cardsForTodayLabel = makeLabel()
    let cardsTotalLabel = makeLabel()
    let cardsNumbersStackView = makeStackView()
    var cardsForToday = 0
    var cardsTotal = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .systemGray5
        
        wordLabel.numberOfLines = 3
        wordLabel.font = .systemFont(ofSize: 40)
        definitionLabel.numberOfLines = 15
        definitionLabel.textAlignment = .left
        wordStackViewVertical.axis = .vertical
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        
        cardsForTodayLabel.numberOfLines = 0
        cardsTotalLabel.numberOfLines = 0
        
        cardsForTodayLabel.textAlignment = .left
        cardsTotalLabel.textAlignment = .left
        
        cardsForTodayLabel.font = .systemFont(ofSize: 25)
        cardsTotalLabel.font = .systemFont(ofSize: 25)
        
        cardsForTodayLabel.text = "Cards to repeat today: \(cardsForToday)"
        cardsTotalLabel.text = "Cards in the deck: \(cardsTotal)"
        cardsNumbersStackView.axis = .vertical
        
        showAnswerButton.addTarget(self, action: #selector(didTapShowAnswerButton), for: .touchUpInside)
        easyButton.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
        goodButton.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
        hardButton.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
        againButton.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
        
        let buttonHeight: CGFloat = 40
        
        addSubview(wordStackViewVertical)
        addSubview(showAnswerButton)
        addSubview(buttonStackView)
        addSubview(cardsNumbersStackView)
        
        wordStackViewVertical.addArrangedSubview(wordLabel)
        wordStackViewVertical.addArrangedSubview(definitionLabel)
        
        buttonStackView.addArrangedSubview(easyButton)
        buttonStackView.addArrangedSubview(goodButton)
        buttonStackView.addArrangedSubview(hardButton)
        buttonStackView.addArrangedSubview(againButton)
        
        cardsNumbersStackView.addArrangedSubview(cardsForTodayLabel)
        cardsNumbersStackView.addArrangedSubview(cardsTotalLabel)
        
        wordStackViewVertical.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        wordStackViewVertical.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        wordStackViewVertical.widthAnchor.constraint(equalToConstant: 350).isActive = true
        
        showAnswerButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        showAnswerButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50).isActive = true
        showAnswerButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        showAnswerButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        buttonStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        buttonStackView.topAnchor.constraint(equalTo: showAnswerButton.bottomAnchor, constant: 20).isActive = true
        buttonStackView.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        buttonStackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        cardsNumbersStackView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20).isActive = true
        cardsNumbersStackView.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor).isActive = true
        cardsNumbersStackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    @objc func didTapShowAnswerButton() {
        print("you did push show answers")
        delegate?.buttonPressed(withTitle: showAnswerButton.currentTitle ?? "")
    }
    
    @objc func didTapButtonStack(sender: UIButton) {
            delegate?.buttonPressed(withTitle: sender.currentTitle ?? "")
    }
    
    func setWordLabelText(newText: String) {
        wordLabel.text = newText
    }
    
    func setDefinitionLabelText(newText: String) {
        definitionLabel.text = newText
    }
    
    func setCardsNumbers(cardsForToday: Int, cardsTotal: Int) {
        self.cardsForToday = cardsForToday
        self.cardsTotal = cardsTotal
        
        cardsForTodayLabel.text = "Cards to repeat today: \(self.cardsForToday)"
        cardsTotalLabel.text = "Cards in the deck: \(self.cardsTotal)"
    }
    
    func setButtonsActive(active: Bool) {
        if active == true {
            showAnswerButton.isEnabled = true
            easyButton.isEnabled = true
            goodButton.isEnabled = true
            hardButton.isEnabled = true
            againButton.isEnabled = true
        } else {
            showAnswerButton.isEnabled = false
            easyButton.isEnabled = false
            goodButton.isEnabled = false
            hardButton.isEnabled = false
            againButton.isEnabled = false
        }
    }
}

protocol CardViewDelegate: AnyObject {
    func buttonPressed(withTitle title: String)
}
