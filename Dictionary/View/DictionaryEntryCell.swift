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
    let partOfSpeechLabel = UILabel()
    let definitionLabel = UILabel()
    let spacerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray5
        
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
        
        let firstStack = UIStackView(arrangedSubviews: [
            wordLabel, phoneticsLabel, spacerView])
        firstStack.axis = .horizontal
        firstStack.alignment = .lastBaseline // 🙏🏻 I spent so much time with constraints and baselines, thanks GOD I found this command
        
        let MainStack = UIStackView(arrangedSubviews: [
            firstStack, partOfSpeechLabel, definitionLabel
        ])
        MainStack.axis = .vertical
        MainStack.spacing = 12
        
        addSubview(MainStack)
        
        spacerView.widthAnchor.constraint(equalToConstant: 300).isActive = true //it's probably better to play around with CH value of spacerView... for now let's stick to thsi temporary solution
        MainStack.translatesAutoresizingMaskIntoConstraints = false
        
        MainStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        MainStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        MainStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        MainStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
