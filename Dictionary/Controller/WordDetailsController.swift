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
    fileprivate let headerReuseIdentifier = "WordDetailsHeaderReuseIdentifier"

    var audioPlayer: AVPlayer?

    let wordLabel = UILabel()
    let word = String()
    
    var partOfSpeech1 = String()
    var partOfSpeech2 = String()
    var partOfSpeech3 = String()
    var wordDefinition1 = NSMutableAttributedString()
    var wordDefinition2 = NSMutableAttributedString()
    var wordDefinition3 = NSMutableAttributedString()
    
    var itemWasAtCell = Int16()
    var isBookmarked: Bool = false
    
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
        configureCells()
        collectionView.register(DictionaryEntryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(WordDetailsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.isPrefetchingEnabled = false

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//        layout.sectionHeadersPinToVisibleBounds = true // to make the header stick to the top, future challenge, doesn't work now, crashes the cells layout
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    // MARK: collectionView methods
    //  if we use collectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    private func configureCells() {
        let count = 0...items.count-1
        for i in count {
            configureCell(index: i)
        }
    }
    
    private func configureCell(index: Int) {
        let item = items[index]

        let JSONMeanings = item.meanings
        let lineBreak = NSAttributedString(string: "\n")

        func setupDefinitions(partOfSpeech: inout String, NSMutableText: inout NSMutableAttributedString, number: Int) {
            partOfSpeech = JSONMeanings[number].partOfSpeech ?? "no info"

            if JSONMeanings[number].definitions.count == 1 {
                NSMutableText = NSMutableAttributedString(string: JSONMeanings[number].definitions[0].definition)

                if let example = JSONMeanings[number].definitions[0].example {
                    let exampleText = NSAttributedString(string: " \(example)", attributes: [.font: UIFont.italicSystemFont(ofSize: 18)])
                    NSMutableText.append(exampleText)
                }
            } else {
                for (index, definition) in JSONMeanings[number].definitions.enumerated() {
                    let content = "\(index + 1). \(definition.definition)"
                    let contentText = NSAttributedString(string: content, attributes: [.font: UIFont.systemFont(ofSize: 18)])
                    NSMutableText.append(contentText)

                    if let example = definition.example {
                        let exampleText = NSAttributedString(string: " \(example)", attributes: [.font: UIFont.italicSystemFont(ofSize: 18)])
                        NSMutableText.append(exampleText)
                    }
                    NSMutableText.append(lineBreak)
                }
            }
        }

        let count = 0...JSONMeanings.count-1
        for number in count {
            switch number {
            case 0:
                setupDefinitions(partOfSpeech: &partOfSpeech1, NSMutableText: &wordDefinition1, number: number)
            case 1:
                setupDefinitions(partOfSpeech: &partOfSpeech2, NSMutableText: &wordDefinition2, number: number)
            case 2:
                setupDefinitions(partOfSpeech: &partOfSpeech3, NSMutableText: &wordDefinition3, number: number)
            default:
                break
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DictionaryEntryCell
        
        let count = 0...items[indexPath.item].meanings.count-1
        for number in count {
            switch number {
            case 0:
                cell.definitionLabel1.attributedText = wordDefinition1
                cell.partOfSpeechLabel1.text = partOfSpeech1
            case 1:
                cell.definitionLabel2.attributedText = wordDefinition2
                cell.partOfSpeechLabel2.text = partOfSpeech2
            case 2:
                cell.definitionLabel3.attributedText = wordDefinition3
                cell.partOfSpeechLabel3.text = partOfSpeech3
            default:
                break
            }
        }
        return cell
    }

    
    // MARK:  UICollectionViewDelegateFlowLayout protocol
        
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width-10, height: 300)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width-10, height: 40)
//    }
//
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! WordDetailsHeaderView
            
            headerView.wordLabel.text = items[0].word
            headerView.phoneticsLabel.text = items[0].phonetic ?? "no phonetics"
            
            return headerView
        }
        
        // Возвращаем пустую ячейку, если это не заголовок
        return UICollectionReusableView()
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40) // Задайте размер ваших заголовков
    }
    
// MARK: star button Functions
//    @objc private func didTapStar() {
//        if let word = wordLabel.text {
//            isBookmarked.toggle()
//
//            if isBookmarked {
//                starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
//                CoreDataService.shared.createItem(name: word, itemCell: itemWasAtCell) // а так работает мразь!
//                wordDetailsDelegate?.refreshList()
//            } else {
//                starButton.setImage(UIImage(systemName: "star"), for: .normal)
//                wordDetailsDelegate?.deleteCurrentCoreDataEntry()
////                CoreDataService.shared.deleteItem(item: coreDataItem)
//            }
//        }
//    }
// MARK: Audio UICollectionViewHeader
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        <#code#>
//    }
// MARK: Audio Functions
    
//    @objc private func didTapHeadphones() {
//        soundButtonIsPressed.toggle()
//        if soundButtonIsPressed {
//            soundButton.setImage(UIImage(systemName: "headphones.circle.fill"), for: .normal)
//            playAudio()
//        } else {
//            soundButton.setImage(UIImage(systemName: "headphones.circle"), for: .normal)
//            stopAudio()
//        }
//    }
    
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
//        soundButton.isEnabled = isEnabled
//        soundButton.tintColor = isEnabled ? .systemBlue : .systemGray
    }


}

// MARK: passInfoToFavorites protocol
protocol passInfoToFavorites {
    func deleteCurrentCoreDataEntry()
    func refreshList()
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
//
//    }
    
//    func setupViews() {
//        if isBookmarked {
//            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
//        } else {
//            starButton.setImage(UIImage(systemName: "star"), for: .normal)
//        }
//    }
