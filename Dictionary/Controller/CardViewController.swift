//
//  CardViewController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 27.11.2023.
//

import UIKit

class CardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .systemGray5
        
        let stackViewVertical: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.axis = .vertical
            view.distribution = .fill
            view.alignment = .fill
            view.spacing = 8.0
            
            return view
        }()
        
        let noteLabel: UILabel = {
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
            button.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
            
            return button
        }()
        
        let hardButton: UIButton = {
            let button = UIButton(type: .system)
            
            button.setTitle("Hard", for: .normal)
            button.titleLabel?.textColor = .black
            button.tintColor = .black
            button.backgroundColor = .white
            button.addTarget(self, action: #selector(didTapButtonStack), for: .touchUpInside)
            
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
        
        noteLabel.text = "some words"
        
        buttonStackView.addArrangedSubview(easyButton)
//        buttonStackView.addArrangedSubview(goodButton)
//        buttonStackView.addArrangedSubview(hardButton)
        buttonStackView.addArrangedSubview(againButton)
    
        stackViewVertical.addArrangedSubview(noteLabel)
        stackViewVertical.addArrangedSubview(showAnswerButton)
        stackViewVertical.addArrangedSubview(buttonStackView)
        view.addSubview(stackViewVertical)
        
        noteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noteLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        
      
    }
    
    @objc func didTapShowAnswerButton() {
        print("you did push show answers")
    }
    
    @objc func didTapButtonStack() {
        print("you did push buttonStack button")
    }
    
}
