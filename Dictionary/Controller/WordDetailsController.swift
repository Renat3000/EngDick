//
//  WordDetailsController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 25.10.2023.
//

import UIKit

class WordDetailsController: UIViewController {
    
    weak var delegate: WordDetailsDelegate?

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
    var definition1 = NSMutableAttributedString()
    var definition2 = NSMutableAttributedString()
    var definition3 = NSMutableAttributedString()
    var itemWasAtCell = Int16()
    
    var coreDataItem = FavoritesItem()
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
        view.addSubview(scrollView)
        
        if isBookmarked {
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        wordLabel.text = word
        phoneticsLabel.text = phonetic
        partOfSpeechLabel1.text = partOfSpeech1
        definitionLabel1.attributedText = definition1
        partOfSpeechLabel2.text = partOfSpeech2
        definitionLabel2.attributedText = definition2
        partOfSpeechLabel3.text = partOfSpeech3
        definitionLabel3.attributedText = definition3
        
        wordLabel.font = .systemFont(ofSize: 30)
        phoneticsLabel.font = .systemFont(ofSize: 20)
        phoneticsLabel.textColor = .systemGray
        partOfSpeechLabel1.font = .systemFont(ofSize: 20)
        partOfSpeechLabel2.font = .systemFont(ofSize: 20)
        partOfSpeechLabel2.font = .systemFont(ofSize: 20)

        definitionLabel1.numberOfLines = 0
        definitionLabel2.numberOfLines = 0
        definitionLabel3.numberOfLines = 0
        
        let wordStack = UIStackView(arrangedSubviews: [
        wordLabel, phoneticsLabel
        ])
        wordStack.axis = .horizontal
        wordStack.translatesAutoresizingMaskIntoConstraints = false
        wordStack.alignment = .lastBaseline
        
        let firstStack = UIStackView(arrangedSubviews: [
            wordStack, starButton
        ])
        firstStack.axis = .horizontal
        firstStack.distribution = .equalSpacing
        firstStack.translatesAutoresizingMaskIntoConstraints = false
        firstStack.alignment = .lastBaseline // 🙏🏻 I spent so much time with constraints and baselines, thanks GOD I found this command
        
        let mainStack = UIStackView(arrangedSubviews: [
        firstStack, partOfSpeechLabel1, definitionLabel1, partOfSpeechLabel2, definitionLabel2, partOfSpeechLabel3, definitionLabel3
        ])
        scrollView.addSubview(mainStack)
        firstStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor).isActive = true
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.alignment = .top
    
        mainStack.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        mainStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
    }
    
    @objc private func didTapStar() {
        if let word = wordLabel.text {
            isBookmarked.toggle()
            
            if isBookmarked {
                starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                delegate?.didToggleBookmark(item: word, itemCell: itemWasAtCell, isBookmarked: isBookmarked)
                print(word,itemWasAtCell,isBookmarked)
            } else {
                starButton.setImage(UIImage(systemName: "star"), for: .normal)
                delegate?.didToggleBookmark(item: coreDataItem, itemCell: nil, isBookmarked: isBookmarked)
            }
        }
    }
}

protocol WordDetailsDelegate: AnyObject {
    func didToggleBookmark(item: Any, itemCell: Int16?, isBookmarked: Bool)
}
