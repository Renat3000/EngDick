//
//  WordDetailsController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 25.10.2023.
//

import UIKit
import AVFoundation

class WordDetailsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HeaderDelegate {
    
    var wordDetailsDelegate: passInfoToFavorites?
    fileprivate let cellId = "dictionaryCell"
    fileprivate let headerReuseIdentifier = "WordDetailsHeaderReuseIdentifier"

    var audioPlayer: AVPlayer?
    var playerItem : AVPlayerItem?

    let word = String()
    var partOfSpeech1 = String()
    var partOfSpeech2 = String()
    var partOfSpeech3 = String()
    var wordDefinition1 = NSMutableAttributedString()
    var wordDefinition2 = NSMutableAttributedString()
    var wordDefinition3 = NSMutableAttributedString()
    
    var itemWasAtCell = Int16()
    var isBookmarked: Bool = false
    var audioIsAvailable: Bool = false
    
    private let items: [JSONStruct] //maybe: private var item: JSONStruct?
    init(items: [JSONStruct], isBookmarked: Bool) {
        
        self.items = items
        self.isBookmarked = isBookmarked
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .systemGray4
        navigationItem.largeTitleDisplayMode = .never
        configureCells()
        collectionView.register(DictionaryEntryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(WordDetailsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//        layout.sectionHeadersPinToVisibleBounds = true // to make the header stick to the top, future challenge, doesn't work now, crashes the cells layout
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    private func configureCells() {
        let count = 0...items.count-1
        for i in count {
            configureCell(index: i)
            print(wordDefinition1)
        }
    }
    
    private func configureCell(index: Int) {
        let item = items[index]
        let phonetics = item.phonetics
        let JSONMeanings = item.meanings
        
//      audio. the thing is, we don't know where in json there's a working audio, so somehow we have to figure it out
        phonetics.forEach {
            if $0.audio != "" {
                if let audio = $0.audio {
                    setupAudioPlayer(urlString: audio)
                    audioIsAvailable = true
                }
            }
        }
        
        let lineBreak = NSAttributedString(string: "\n")

        func setupDefinitions(partOfSpeech: inout String, NSMutableText: inout NSMutableAttributedString, number: Int) {
            partOfSpeech = JSONMeanings[number].partOfSpeech ?? "no info"
            
                for (index, definition) in JSONMeanings[number].definitions.enumerated() {
                    let content = "\(index + 1). \(definition.definition)"
                    let contentText = NSAttributedString(string: content, attributes: [.font: UIFont.systemFont(ofSize: 18)])
                    NSMutableText.append(contentText)
                    
                    if let example = definition.example {
                        let exampleText = NSAttributedString(string: " \(example)", attributes: [.font: UIFont.italicSystemFont(ofSize: 18)])
                        NSMutableText.append(exampleText)
                    }
                    NSMutableText.append(lineBreak)
                    
                    let synonyms = definition.synonyms
                    if !synonyms.isEmpty {
                        let synonymsText = NSAttributedString(string: "SYNONYMS: \(synonyms.joined(separator: ", "))", attributes: [.font: UIFont.monospacedSystemFont(ofSize: 18, weight: .medium)])
                        NSMutableText.append(synonymsText)
                        NSMutableText.append(lineBreak)
                    }
                    
                    let antonyms = definition.antonyms
                    if !antonyms.isEmpty {
                        let antonymsText = NSAttributedString(string: "ANTONYMS: \(antonyms.joined(separator: ", "))", attributes: [.font: UIFont.monospacedSystemFont(ofSize: 18, weight: .medium)])
                        NSMutableText.append(antonymsText)
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
    
    // MARK: collectionView methods
    //  if we use collectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DictionaryEntryCell
        
        cell.partOfSpeechLabel1.text = partOfSpeech1
        cell.definitionLabel1.attributedText = wordDefinition1
        cell.partOfSpeechLabel2.text = partOfSpeech2
        cell.definitionLabel2.attributedText = wordDefinition2
        cell.partOfSpeechLabel3.text = partOfSpeech3
        cell.definitionLabel3.attributedText = wordDefinition3
        
        return cell
    }

    
    // MARK:  UICollectionViewDelegateFlowLayout protocol
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! WordDetailsHeaderView
            
            headerView.delegate = self
            headerView.wordLabel.text = items[0].word
            headerView.phoneticsLabel.text = items[0].phonetic ?? "no phonetics"
            headerView.setAudioButtonEnabled(audioIsAvailable)
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
// MARK: star button Functions
    @objc func didTapStar() {
//        if let word = wordLabel.text {
//            isBookmarked.toggle()

//            if isBookmarked {
//                starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
//                CoreDataService.shared.createItem(name: word, itemCell: itemWasAtCell) // а так работает мразь!
//                wordDetailsDelegate?.refreshList()
//            } else {
//                starButton.setImage(UIImage(systemName: "star"), for: .normal)
//                wordDetailsDelegate?.deleteCurrentCoreDataEntry()
//                CoreDataService.shared.deleteItem(item: coreDataItem)
//            }
        print("tapped the star")
        
        }
//    }
// MARK: Audio UICollectionViewHeader & Audio Functions
    
    @objc internal func didTapHeadphones(soundButtonIsPressed: Bool) {

        if soundButtonIsPressed {
            playAudio()
        } else {
            stopAudio()
        }
    }
    
    func setupAudioPlayer(urlString: String) {
        if let audioURL = URL(string: urlString) {
            playerItem = AVPlayerItem(url: audioURL)
            audioPlayer = AVPlayer(playerItem: playerItem)
            NotificationCenter.default.addObserver(self, selector: #selector(audioDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        }
    }
    
    func playAudio() {
        audioPlayer?.seek(to: CMTime.zero)
        audioPlayer?.play()
    }
    func stopAudio() {
        audioPlayer?.pause()
    }
    
    @objc func audioDidFinishPlaying(_ notification: Notification) {
        print("Audio finished playing.")
        audioDidFinishNotification()
    }
    
    func audioDidFinishNotification() {
            NotificationCenter.default.post(name: NSNotification.Name("AudioDidFinishPlaying"), object: nil)
    }
}

// MARK: passInfoToFavorites protocol
protocol passInfoToFavorites {
    func deleteCurrentCoreDataEntry()
    func refreshList()
}
