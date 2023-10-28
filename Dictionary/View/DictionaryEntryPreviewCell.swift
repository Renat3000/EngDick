//
//  DictionaryEntryPreviewCell.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 21.10.2023.
//

import UIKit

class DictionaryEntryPreviewCell: UICollectionViewCell {
    
    let wordLabel = UILabel()
    let phoneticsLabel = UILabel()
    let partOfSpeechLabel1 = UILabel()
    let definitionLabel1 = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray5
        layer.cornerRadius = min(frame.width, frame.height) / 10
        clipsToBounds = true
        
        wordLabel.text = "word Label"
        phoneticsLabel.text = "phonetics Label"
        partOfSpeechLabel1.text = "part Of Speech Label"
        definitionLabel1.text = "definition Label"
        
        wordLabel.font = .systemFont(ofSize: 30)
        phoneticsLabel.font = .systemFont(ofSize: 20)
        phoneticsLabel.textColor = .systemGray
        
        partOfSpeechLabel1.font = .systemFont(ofSize: 20)
        
        definitionLabel1.font = .systemFont(ofSize: 18)
        definitionLabel1.numberOfLines = 2
        
        let firstStack = UIStackView(arrangedSubviews: [
            wordLabel, phoneticsLabel
        ])
        firstStack.axis = .horizontal
        firstStack.alignment = .lastBaseline // 🙏🏻 I spent so much time with constraints and baselines, thanks GOD I found this command
        
        let mainStack = UIStackView(arrangedSubviews: [
            firstStack, partOfSpeechLabel1, definitionLabel1
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        
        addSubview(mainStack)
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.alignment = .top
        mainStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
