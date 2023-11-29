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
    
    let wordStackViewVertical: UIStackView = {
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = .white
        label.backgroundColor = .systemGray4
        label.font = .systemFont(ofSize: 36)
        label.textAlignment = .center
        return label
    }()
    
    let definitionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.backgroundColor = .systemGray4
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    let showAnswerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("Show Answer", for: .normal)
        button.titleLabel?.textColor = .black
        button.tintColor = .black
        button.backgroundColor = .white
        
        button.addTarget(self, action: #selector(didTapShowAnswerButton), for: .touchUpInside)
        return button
    }()
    
    let easyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("Easy", for: .normal)
        button.titleLabel?.textColor = .black
        button.tintColor = .black
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
        
        return button
    }()
    
    let goodButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("Good", for: .normal)
        button.titleLabel?.textColor = .black
        button.tintColor = .black
        button.backgroundColor = .white
//            button.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
        
        return button
    }()
    
    let hardButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("Hard", for: .normal)
        button.titleLabel?.textColor = .black
        button.tintColor = .black
        button.backgroundColor = .white
//            button.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
        
        return button
    }()
    
    let againButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
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
        //old
//        wordLabel.text = "some words"
//        buttonStackView.addArrangedSubview(easyButton)
//        buttonStackView.addArrangedSubview(goodButton)
//        buttonStackView.addArrangedSubview(hardButton)
//        buttonStackView.addArrangedSubview(againButton)
//
//        wordStackViewVertical.addArrangedSubview(wordLabel)
//        wordStackViewVertical.addArrangedSubview(definitionLabel)
//
//        stackViewVertical.addArrangedSubview(wordStackViewVertical)
//        stackViewVertical.addArrangedSubview(showAnswerButton)
//        stackViewVertical.addArrangedSubview(buttonStackView)
//        addSubview(stackViewVertical)
//
//        wordLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        wordLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -200).isActive = true
//
//        wordStackViewVertical.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
////        wordStackViewVertical.widthAnchor.constraint(equalToConstant: 150).isActive = true
//
////        showAnswerButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
////        showAnswerButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
////        wordStackViewVertical.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
////        wordStackViewVertical.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
//
//        stackViewVertical.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        stackViewVertical.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        //new
        
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
        wordStackViewVertical.widthAnchor.constraint(equalToConstant: 400).isActive = true
        
        showAnswerButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        showAnswerButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50).isActive = true
        showAnswerButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        showAnswerButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        buttonStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        buttonStackView.topAnchor.constraint(equalTo: showAnswerButton.bottomAnchor, constant: 20).isActive = true
        buttonStackView.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        buttonStackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
//        wordLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        wordLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -200).isActive = true
//
//        wordStackViewVertical.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
////        wordStackViewVertical.widthAnchor.constraint(equalToConstant: 150).isActive = true
//
////        showAnswerButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
////        showAnswerButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
////        wordStackViewVertical.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
////        wordStackViewVertical.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
//
//        stackViewVertical.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        stackViewVertical.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
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
    
    func setWordLabelText(newText: String) {
        wordLabel.text = newText
    }
    
    func setDefinitionLabelText(newText: String) {
        definitionLabel.text = newText
    }
}

protocol CardViewDelegate: AnyObject {
    func buttonPressed(withTitle title: String)
}
