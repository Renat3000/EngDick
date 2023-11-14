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
    var partOfSpeech1 = String()
    var partOfSpeech2 = String()
    var partOfSpeech3 = String()
    
    let definitionLabel1 = UILabel()
    let definitionLabel2 = UILabel()
    let definitionLabel3 = UILabel()
    
    var wordDefinition1 = NSMutableAttributedString()
    var wordDefinition2 = NSMutableAttributedString()
    var wordDefinition3 = NSMutableAttributedString()
    
    
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
        partOfSpeechLabel1.text = partOfSpeech1
    
        definitionLabel1.font = .systemFont(ofSize: 18)
        
        definitionLabel1.attributedText = wordDefinition1
        partOfSpeechLabel2.text = partOfSpeech2
        definitionLabel2.attributedText = wordDefinition2
        partOfSpeechLabel3.text = partOfSpeech3
        definitionLabel3.attributedText = wordDefinition3
        
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
