//
//  DictionaryEntryCell.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 21.10.2023.
//

import UIKit

class DictionaryEntryCell: UICollectionViewCell {
    
    let wordLabel = UILabel()
    let phoneticsLabel = UILabel()
    
    let partOfSpeechLabel1 = UILabel()
    let partOfSpeechLabel2 = UILabel()
    let partOfSpeechLabel3 = UILabel()
    
    let definitionLabel1 = UILabel()
    let definitionLabel2 = UILabel()
    let definitionLabel3 = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray5
//        layer.cornerRadius = min(frame.width, frame.height) / 10
        clipsToBounds = true
        
        wordLabel.text = "word Label"
        wordLabel.font = .systemFont(ofSize: 30)
        phoneticsLabel.font = .systemFont(ofSize: 20)
        phoneticsLabel.textColor = .systemGray
        
        definitionLabel1.font = .systemFont(ofSize: 18)
        definitionLabel2.font = .systemFont(ofSize: 18)
        definitionLabel3.font = .systemFont(ofSize: 18)
            
        partOfSpeechLabel1.font = .systemFont(ofSize: 20)
        partOfSpeechLabel2.font = .systemFont(ofSize: 20)
        partOfSpeechLabel3.font = .systemFont(ofSize: 20)
        
        definitionLabel1.numberOfLines = 0
        definitionLabel2.numberOfLines = 0
        definitionLabel3.numberOfLines = 0
        
        let wordStack = UIStackView(arrangedSubviews: [
            wordLabel, phoneticsLabel
        ])
        wordStack.translatesAutoresizingMaskIntoConstraints = false
        wordStack.axis = .horizontal
        wordStack.alignment = .lastBaseline // 🙏🏻 I spent so much time with constraints and baselines, thanks GOD I found this command
        wordStack.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        let mainStack = UIStackView(arrangedSubviews: [
            wordStack, partOfSpeechLabel1, definitionLabel1, partOfSpeechLabel2, definitionLabel2, partOfSpeechLabel3, definitionLabel3
        ])
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.alignment = .top
        mainStack.axis = .vertical
        mainStack.spacing = 12
        
        addSubview(mainStack)
        
        mainStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        mainStack.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 16).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
