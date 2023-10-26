//
//  InDepthScreen.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 25.10.2023.
//

import UIKit

class WordDetailsController: UIViewController {
    
    let wordLabel = UILabel()
    let phoneticsLabel = UILabel()
    let partOfSpeechLabel = UILabel()
    let definitionLabel = UILabel()
    let spacerView = UIView()
    let favorites = FavoritesController()
    let item = FavoritesItem()
    var isBookmarked: Bool = false
    let starButton: UIButton = {
        let button = UIButton(type: .system)
        let starImage = UIImage(systemName: "star")
        button.setImage(starImage, for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(didTapStar), for: .touchUpInside)

        return button
    }()
    
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
        spacerView.frame = .init(x: 0, y: 0, width: 100, height: 4)
        definitionLabel.font = .systemFont(ofSize: 18)
        definitionLabel.numberOfLines = 0
        
        let firstStack = UIStackView(arrangedSubviews: [
            wordLabel, phoneticsLabel, spacerView, starButton])
        
        firstStack.translatesAutoresizingMaskIntoConstraints = false
        firstStack.axis = .horizontal
//        firstStack.distribution = .fillProportionally
        firstStack.widthAnchor.constraint(equalToConstant: 398).isActive = true
        firstStack.alignment = .lastBaseline // 🙏🏻 I spent so much time with constraints and baselines, thanks GOD I found this command
        
        let mainStack = UIStackView(arrangedSubviews: [
            firstStack, partOfSpeechLabel, definitionLabel
        ])
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.spacing = 12
        
        view.addSubview(mainStack)
        
        mainStack.alignment = .top
        mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc private func didTapStar() {
        if let word = wordLabel.text {
            isBookmarked.toggle()
            
            if isBookmarked {
                starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                favorites.createItem(name: word)
            } else {
                starButton.setImage(UIImage(systemName: "star"), for: .normal)
                // need to delete the item/word from the list, don't know how yet
//                favorites.deleteItem(item: word) - doesn't work. Cannot convert value of type 'String' to expected argument type 'FavoritesItem'
            }
        }
    }
}

