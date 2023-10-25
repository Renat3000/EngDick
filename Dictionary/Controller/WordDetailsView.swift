//
//  InDepthScreen.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 25.10.2023.
//

import UIKit

class WordDetailsController: UIViewController {
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupViews()
    }
    
    func setupViews(){
        
        let wordLabel = UILabel()
        let phoneticsLabel = UILabel()
        let partOfSpeechLabel = UILabel()
        let definitionLabel = UILabel()
        let spacerView = UIView()
        
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = min(view.frame.width, view.frame.height) / 10
        view.clipsToBounds = true
        
        wordLabel.text = "word Label"
        phoneticsLabel.text = "phonetics Label"
        partOfSpeechLabel.text = "part Of Speech Label"
        definitionLabel.text = "definition Label"
        
        wordLabel.font = .systemFont(ofSize: 30)
        phoneticsLabel.font = .systemFont(ofSize: 20)
        phoneticsLabel.textColor = .systemGray
        partOfSpeechLabel.font = .systemFont(ofSize: 20)
        spacerView.backgroundColor = .clear
        definitionLabel.font = .systemFont(ofSize: 18)
        definitionLabel.numberOfLines = 0
        
        let firstStack = UIStackView(arrangedSubviews: [
            wordLabel, phoneticsLabel, spacerView])
        firstStack.axis = .horizontal
        firstStack.alignment = .lastBaseline // 🙏🏻 I spent so much time with constraints and baselines, thanks GOD I found this command
        
        let mainStack = UIStackView(arrangedSubviews: [
            firstStack, partOfSpeechLabel, definitionLabel
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        
        view.addSubview(mainStack)
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainStack.alignment = .top
        mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
    }
}

