//
//  InDepthScreen.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 25.10.2023.
//

import UIKit

class WordDetailsController: UIViewController {
    
    let scrollView = UIScrollView()
    
    let wordLabel = UILabel()
    var word = String()
    
    let phoneticsLabel = UILabel()
    var phonetic = String()
    
    let partOfSpeechLabel1 = UILabel()
    let partOfSpeechLabel2 = UILabel()
    let partOfSpeechLabel3 = UILabel()
    var partOfSpeech1 = String()
    var partOfSpeech2 = String()
    var partOfSpeech3 = String()
    
    let definitionLabel1 = UILabel()
    let definitionLabel2 = UILabel()
    let definitionLabel3 = UILabel()
    var definition1 = String()
    var definition2 = String()
    var definition3 = String()
    
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
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        setupViews()
    }
    
    func setupViews(){
        
        view.backgroundColor = .systemGray5
//        view.layer.cornerRadius = min(view.frame.width, view.frame.height) / 10
        view.clipsToBounds = true
        
        wordLabel.text = word
        phoneticsLabel.text = phonetic
        partOfSpeechLabel1.text = partOfSpeech1
        definitionLabel1.text = definition1
        partOfSpeechLabel2.text = partOfSpeech2
        definitionLabel2.text = definition2
        partOfSpeechLabel3.text = partOfSpeech3
        definitionLabel3.text = definition3
        
        wordLabel.font = .systemFont(ofSize: 30)
        phoneticsLabel.font = .systemFont(ofSize: 20)
        phoneticsLabel.textColor = .systemGray
        partOfSpeechLabel1.font = .systemFont(ofSize: 20)
        partOfSpeechLabel2.font = .systemFont(ofSize: 20)
        partOfSpeechLabel2.font = .systemFont(ofSize: 20)
        spacerView.backgroundColor = .clear
        spacerView.frame = .init(x: 0, y: 0, width: 100, height: 4)
        definitionLabel1.font = .systemFont(ofSize: 18)
        definitionLabel1.numberOfLines = 0
        definitionLabel2.font = .systemFont(ofSize: 18)
        definitionLabel2.numberOfLines = 0
        definitionLabel3.font = .systemFont(ofSize: 18)
        definitionLabel3.numberOfLines = 0
    
        let firstStack = UIStackView(arrangedSubviews: [
                  wordLabel, phoneticsLabel, spacerView, starButton
        ])
        firstStack.axis = .horizontal
        firstStack.distribution = .fillProportionally
        firstStack.translatesAutoresizingMaskIntoConstraints = false
        firstStack.alignment = .lastBaseline // 🙏🏻 I spent so much time with constraints and baselines, thanks GOD I found this command
        
        let mainStack = UIStackView(arrangedSubviews: [
        firstStack, partOfSpeechLabel1, definitionLabel1, partOfSpeechLabel2, definitionLabel2, partOfSpeechLabel2, definitionLabel3
        ])
        scrollView.addSubview(mainStack)
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.alignment = .top
        mainStack.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8).isActive = true
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height*2)

        // Добавьте scrollView как подвидимость контроллера
        view.addSubview(scrollView)

        // Установите ограничения для scrollView, чтобы он занимал всю доступную область
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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

