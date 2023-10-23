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
        layer.cornerRadius = min(frame.width, frame.height) / 10
        clipsToBounds = true
        
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
        
        addSubview(mainStack)
        
//        spacerView.widthAnchor.constraint(equalToConstant: 200).isActive = true //it's probably better to play around with CH value of spacerView... for now let's stick to thsi temporary solution
        mainStack.translatesAutoresizingMaskIntoConstraints = false
//        mainStack.distribution = .equalSpacing
        mainStack.alignment = .top
        mainStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
//        mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
