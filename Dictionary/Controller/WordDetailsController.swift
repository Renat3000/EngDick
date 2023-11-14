//
//  WordDetailsController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 25.10.2023.
//

import UIKit
import AVFoundation

class WordDetailsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var wordDetailsDelegate: passInfoToFavorites?
    fileprivate let cellId = "dictionaryCell"
    var audioPlayer: AVPlayer?

    let wordLabel = UILabel()
    let word = String()
    
    let scrollView = UIScrollView()
    var itemWasAtCell = Int16()
    var isBookmarked: Bool = false
    
    let starButton: UIButton = {
        let button = UIButton(type: .system)
        let starImage = UIImage(systemName: "star")
        button.setImage(starImage, for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(didTapStar), for: .touchUpInside)

        return button
    }()
    
    var soundButtonIsPressed: Bool = false
    let soundButton: UIButton = {
        let button = UIButton(type: .system)
        let headphonesImage = UIImage(systemName: "headphones.circle")
        button.setImage(headphonesImage, for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(didTapHeadphones), for: .touchUpInside)

        return button
    }()
    
    private let items: [JSONStruct] //maybe so: private var item: JSONStruct?
    init(items: [JSONStruct], isBookmarked: Bool) {
        
        self.items = items
        self.isBookmarked = isBookmarked
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .systemGray4
        navigationItem.largeTitleDisplayMode = .never
        collectionView.register(DictionaryEntryCell.self, forCellWithReuseIdentifier: cellId)
//        setupLabels()
//        setupViews()
    }
    
    // MARK: collectionView methods
    //  if we use collectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            return JSONTopResult.count
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DictionaryEntryCell
        
        cell.wordLabel.text = items[indexPath.item].word
        cell.phoneticsLabel.text = items[indexPath.item].phonetic
        
        let JSONMeanings = items[indexPath.item].meanings
        cell.partOfSpeechLabel1.text = JSONMeanings[0].partOfSpeech
        
        cell.definitionLabel1.text = String()
        cell.definitionLabel1.text = JSONMeanings[0].definitions[0].definition
        
        if JSONMeanings[0].definitions.count > 1 {
            cell.definitionLabel2.text = JSONMeanings[0].definitions[1].definition
//            if JSONMeanings[0].definitions[2] != nil {
//                cell.definitionLabel3.text = JSONMeanings[0].definitions[2].definition
//            }
        }
        
        return cell
    }
    
    // MARK:  UICollectionViewDelegateFlowLayout protocol
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-10, height: 300)
    }
    
//    func setupLabels() {
//        setSoundButtonEnabled(false)
//        word = items.word
//        phonetic = items.phonetic ?? "no phonetics"
//        let meaning = items.meanings
//        let phonetics = items.phonetics
//
////        audio. the thing is, we don't know where in json there's a working audio, so somehow we have to figure it out
//        phonetics.forEach {
//            if $0.audio != "" {
//            if let audio = $0.audio {
//                setupAudioPlayer(urlString: audio)
//                setSoundButtonEnabled(true)
//                }
//            }
//        }
//
//        let lineBreak = NSAttributedString(string: "\n")
//
//        func setupDefinitions(wdPartOfSpeech: inout String, wdDefinition: inout NSMutableAttributedString, number: Int) {
//            wdPartOfSpeech = meaning[number].partOfSpeech ?? "no info"
//
//            if meaning[number].definitions.count == 1 {
//                wdDefinition = NSMutableAttributedString(string: meaning[number].definitions[0].definition)
//
//                if let example = meaning[number].definitions[0].example {
//                    let exampleText = NSAttributedString(string: " \(example)", attributes: [.font: UIFont.italicSystemFont(ofSize: 18)])
//                    wdDefinition.append(exampleText)
//                }
//            } else {
//                for (index, definition) in meaning[number].definitions.enumerated() {
//                    let content = "\(index + 1). \(definition.definition)"
//                    let contentText = NSAttributedString(string: content, attributes: [.font: UIFont.systemFont(ofSize: 18)])
//                    wdDefinition.append(contentText)
//
//                    if let example = definition.example {
//                        let exampleText = NSAttributedString(string: " \(example)", attributes: [.font: UIFont.italicSystemFont(ofSize: 18)])
//                        wdDefinition.append(exampleText)
//                    }
//                    wdDefinition.append(lineBreak)
//                }
//            }
//        }
//
//        let count = 0...meaning.count-1
//        for number in count {
//            switch number {
//            case 0:
//                setupDefinitions(wdPartOfSpeech: &partOfSpeech1, wdDefinition: &wordDefinition1, number: number)
//            case 1:
//                setupDefinitions(wdPartOfSpeech: &partOfSpeech2, wdDefinition: &wordDefinition2, number: number)
//            case 2:
//                setupDefinitions(wdPartOfSpeech: &partOfSpeech3, wdDefinition: &wordDefinition3, number: number)
//            default:
//                break
//            }
//        }
//    }
    
//    func setupViews() {
//
//        view.backgroundColor = .systemGray5
////        view.layer.cornerRadius = min(view.frame.width, view.frame.height) / 10
//        view.clipsToBounds = true
//        view.addSubview(scrollView)
//
//        if isBookmarked {
//            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
//        } else {
//            starButton.setImage(UIImage(systemName: "star"), for: .normal)
//        }
//        wordLabel.text = word
//        phoneticsLabel.text = phonetic
//        partOfSpeechLabel1.text = partOfSpeech1
//        definitionLabel1.attributedText = wordDefinition1
//        partOfSpeechLabel2.text = partOfSpeech2
//        definitionLabel2.attributedText = wordDefinition2
//        partOfSpeechLabel3.text = partOfSpeech3
//        definitionLabel3.attributedText = wordDefinition3
//
//        wordLabel.font = .systemFont(ofSize: 30)
//        phoneticsLabel.font = .systemFont(ofSize: 20)
//        phoneticsLabel.textColor = .systemGray
//        partOfSpeechLabel1.font = .systemFont(ofSize: 20)
//        partOfSpeechLabel2.font = .systemFont(ofSize: 20)
//        partOfSpeechLabel2.font = .systemFont(ofSize: 20)
//
//        definitionLabel1.numberOfLines = 0
//        definitionLabel2.numberOfLines = 0
//        definitionLabel3.numberOfLines = 0
//
//        let wordStack = UIStackView(arrangedSubviews: [
//        wordLabel, phoneticsLabel
//        ])
//        wordStack.axis = .horizontal
//        wordStack.translatesAutoresizingMaskIntoConstraints = false
//        wordStack.alignment = .lastBaseline
//
//        let firstStack = UIStackView(arrangedSubviews: [
//            wordStack, soundButton, starButton
//        ])
//        firstStack.axis = .horizontal
//        firstStack.distribution = .equalSpacing
//        firstStack.translatesAutoresizingMaskIntoConstraints = false
//        firstStack.alignment = .lastBaseline // 🙏🏻 I spent so much time with constraints and baselines, thanks GOD I found this command
//
//        let mainStack = UIStackView(arrangedSubviews: [
//        firstStack, partOfSpeechLabel1, definitionLabel1, partOfSpeechLabel2, definitionLabel2, partOfSpeechLabel3, definitionLabel3
//        ])
//        scrollView.addSubview(mainStack)
//        firstStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor).isActive = true
//        mainStack.translatesAutoresizingMaskIntoConstraints = false
//        mainStack.axis = .vertical
//        mainStack.spacing = 12
//        mainStack.alignment = .top
//
//        mainStack.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        mainStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        mainStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        mainStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//        mainStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//
//        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
//    }
    
    @objc private func didTapStar() {
        if let word = wordLabel.text {
            isBookmarked.toggle()
            
            if isBookmarked {
                starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                CoreDataService.shared.createItem(name: word, itemCell: itemWasAtCell) // а так работает мразь!
                wordDetailsDelegate?.refreshList()
            } else {
                starButton.setImage(UIImage(systemName: "star"), for: .normal)
                wordDetailsDelegate?.deleteCurrentCoreDataEntry()
//                CoreDataService.shared.deleteItem(item: coreDataItem)
            }
        }
    }

// MARK: Audio Functions
    
    @objc private func didTapHeadphones() {
        soundButtonIsPressed.toggle()
        if soundButtonIsPressed {
            soundButton.setImage(UIImage(systemName: "headphones.circle.fill"), for: .normal)
            playAudio()
        } else {
            soundButton.setImage(UIImage(systemName: "headphones.circle"), for: .normal)
            stopAudio()
        }
    }
    
    func setupAudioPlayer(urlString: String) {
        if let audioURL = URL(string: urlString) {
            audioPlayer = AVPlayer(url: audioURL)
        }
    }
    
    func playAudio() {
        audioPlayer?.play()
    }
    func stopAudio() {
        audioPlayer?.pause()
    }
    
    func setSoundButtonEnabled(_ isEnabled: Bool) {
        soundButton.isEnabled = isEnabled
        soundButton.tintColor = isEnabled ? .systemBlue : .systemGray
    }


}
// MARK: passInfoToFavorites protocol
protocol passInfoToFavorites {
    func deleteCurrentCoreDataEntry()
    func refreshList()
}
