//
//  CardView.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 28.11.2023.
//

import UIKit

class CardView: UIView {

    weak var delegate: CardViewDelegate?
    
    let stackViewVertical: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 8.0
        
        return view
    }()
    
    let wordLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        label.textColor = .white
        label.backgroundColor = .systemGray4
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    let showAnswerButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Show Answers", for: .normal)
        button.titleLabel?.textColor = .black
        button.tintColor = .black
        button.backgroundColor = .white
        
        button.addTarget(self, action: #selector(didTapShowAnswerButton), for: .touchUpInside)
        return button
    }()
    
    let easyButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Easy", for: .normal)
        button.titleLabel?.textColor = .black
        button.tintColor = .black
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
        
        return button
    }()
    
    let goodButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Good", for: .normal)
        button.titleLabel?.textColor = .black
        button.tintColor = .black
        button.backgroundColor = .white
//            button.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
        
        return button
    }()
    
    let hardButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Hard", for: .normal)
        button.titleLabel?.textColor = .black
        button.tintColor = .black
        button.backgroundColor = .white
//            button.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
        
        return button
    }()
    
    let againButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Again", for: .normal)
        button.titleLabel?.textColor = .black
        button.tintColor = .black
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
        
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 8.0
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .systemGray5
        
        wordLabel.text = "some words"
        buttonStackView.addArrangedSubview(easyButton)
//        buttonStackView.addArrangedSubview(goodButton)
//        buttonStackView.addArrangedSubview(hardButton)
        buttonStackView.addArrangedSubview(againButton)
    
        stackViewVertical.addArrangedSubview(wordLabel)
        stackViewVertical.addArrangedSubview(showAnswerButton)
        stackViewVertical.addArrangedSubview(buttonStackView)
        addSubview(stackViewVertical)
        
        wordLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        wordLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func didTapShowAnswerButton() {
        print("you did push show answers")
        delegate?.buttonPressed(withTitle: showAnswerButton.currentTitle ?? "")
    }
    
    @objc func didTapButtonStack(sender: UIButton) {
   
        switch sender {
            case easyButton:
                print("Нажата кнопка Easy")
            case againButton:
                print("Нажата кнопка Again")
            default:
                break
            }
        
            delegate?.buttonPressed(withTitle: sender.currentTitle ?? "")
    }
    
    func setLabelText(newText: String) {
        wordLabel.text = newText
    }
    
}

protocol CardViewDelegate: AnyObject {
    func buttonPressed(withTitle title: String)
}
