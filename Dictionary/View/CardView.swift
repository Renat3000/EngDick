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
        definitionLabel.numberOfLines = 0
        wordStackViewVertical.axis = .vertical
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        
        showAnswerButton.addTarget(self, action: #selector(didTapShowAnswerButton), for: .touchUpInside)
        easyButton.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
        goodButton.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
        hardButton.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
        againButton.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
        
        let buttonHeight: CGFloat = 40
        
        addSubview(wordStackViewVertical)
        addSubview(showAnswerButton)
        addSubview(buttonStackView)
        
        wordStackViewVertical.addArrangedSubview(wordLabel)
        wordStackViewVertical.addArrangedSubview(definitionLabel)
        
        buttonStackView.addArrangedSubview(easyButton)
        buttonStackView.addArrangedSubview(goodButton)
        buttonStackView.addArrangedSubview(hardButton)
        buttonStackView.addArrangedSubview(againButton)
        
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
