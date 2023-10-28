//
//  DictionaryController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 18.10.2023.
//

import UIKit

class DictionaryController: UICollectionViewController, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {

    let dictionaryView: DictionaryView
    fileprivate let cellId = "dictionaryCell"
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    init() {
        dictionaryView = DictionaryView()
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .systemGray4
//        view.addSubview(dictionaryView)
//        dictionaryView.fillSuperview()
        loadSearchBar()
        collectionView.register(DictionaryEntryPreviewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate func loadSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate var JSONTopResult = [JSONStruct]()
    fileprivate var JSONMeanings = [Meaning]()
    
    fileprivate func fetchDictionary(searchTerm: String) {
        //get back json-fetched data from the Service file
        print("firing off request, just wait!")
        Service.shared.fetchJSON(searchTerm: searchTerm) { (JSONStruct, err)  in
            
            if let err = err {
                print("failed to fetch dictionary entries", err)
                self.displayErrorAlert(message: "failed to fetch dictionary entries") // actually we can just use err.localizedDescription
                return
            }
            
            self.JSONTopResult = JSONStruct
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return JSONTopResult.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DictionaryEntryPreviewCell

        cell.wordLabel.text = JSONTopResult[indexPath.item].word
        cell.phoneticsLabel.text = JSONTopResult[indexPath.item].phonetic
        
        self.JSONMeanings = JSONTopResult[indexPath.item].meanings
        cell.partOfSpeechLabel1.text = JSONMeanings[0].partOfSpeech
        
        cell.definitionLabel1.text = String()
        cell.definitionLabel1.text = JSONMeanings[0].definitions[0].definition
        
        if JSONMeanings[0].definitions.count > 1 {
            cell.definitionLabel1.text?.append(" ...")
        }
    
        return cell
    }
    
    //only available if we have UICollectionViewDelegateFlowLayout protocol
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-10, height: 150)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var item = JSONTopResult[indexPath.item]
        let wdController = WordDetailsController()
        
        wdController.word = item.word
        wdController.phonetic = item.phonetic ?? "no phonetics"
        
        self.JSONMeanings = item.meanings
        let count = 0...JSONMeanings.count-1
        for number in count {
            switch number {
            case 0:
                wdController.partOfSpeech1 = JSONMeanings[number].partOfSpeech ?? "no info"
                
                if JSONMeanings[number].definitions.count == 1 {
                    wdController.definition1 = JSONMeanings[number].definitions[0].definition
                    
                    if let example = JSONMeanings[number].definitions[0].example {
                        wdController.definition1.append("\nExample: \(example)")
                    }
                    
                } else {
                    wdController.definition1 = String()
                    for (index, definition) in JSONMeanings[number].definitions.enumerated() {
                        let content = "\(index + 1). \(definition.definition)"
                        wdController.definition1.append("\n\(content)")
                        
                        if let example = definition.example {
                            wdController.definition1.append("\nExample: \(example)")
                        }
                        
                    }
                    // old, not enumerated
//                    JSONMeanings[number].definitions.forEach({
//                        wdController.definition1.append("\n\($0.definition)")
//                    })
                }
                
            case 1:
                wdController.partOfSpeech2 = JSONMeanings[number].partOfSpeech ?? "no info"
//                item = JSONTopResult[indexPath.item]
                if JSONMeanings[number].definitions.count == 1 {
                    wdController.definition2 = JSONMeanings[number].definitions[0].definition
                   
                    if let example = JSONMeanings[number].definitions[0].example {
                        wdController.definition2.append("\nExample: \(example)")
                    }
                    
                } else {
                    wdController.definition2 = String()
                    for (index, definition) in JSONMeanings[number].definitions.enumerated() {
                        let content = "\(index + 1). \(definition.definition)"
                        wdController.definition2.append("\n\(content)")
                        if let example = definition.example {
                            wdController.definition2.append("\nExample: \(example)")
                        }
                    }
                }
                
            case 2:
                wdController.partOfSpeech3 = JSONMeanings[number].partOfSpeech ?? "no info"
//                item = JSONTopResult[indexPath.item]
                if JSONMeanings[number].definitions.count == 1 {
                    wdController.definition3 = JSONMeanings[number].definitions[0].definition
                   
                    if let example = JSONMeanings[number].definitions[0].example {
                        wdController.definition3.append("\nExample: \(example)")
                    }
                    
                } else {
                    wdController.definition3 = String()
                    for (index, definition) in JSONMeanings[number].definitions.enumerated() {
                        let content = "\(index + 1). \(definition.definition)"
                        wdController.definition3.append("\n\(content)")
                        
                        if let example = definition.example {
                            wdController.definition3.append("\nExample: \(example)")
                        }
                    }
                }
                
            default:
                break
            }
        }
        navigationController?.pushViewController(wdController, animated: true)
//        print(item)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          if let searchText = searchBar.text {
              fetchDictionary(searchTerm: searchText)
          }
          searchBar.resignFirstResponder() // to hide the keyboard
      }
    
    //error message in case we don't have a word in the dictionary or there's no internet connection
    func displayErrorAlert(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
