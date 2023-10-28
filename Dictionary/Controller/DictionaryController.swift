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
        collectionView.register(DictionaryEntryCell.self, forCellWithReuseIdentifier: cellId)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DictionaryEntryCell

        cell.wordLabel.text = JSONTopResult[indexPath.item].word
        cell.phoneticsLabel.text = JSONTopResult[indexPath.item].phonetic
        
        self.JSONMeanings = JSONTopResult[indexPath.item].meanings
        let count = 0...JSONMeanings.count-1
        
        for number in count {
            switch number {
            case 0:
                cell.partOfSpeechLabel1.text = JSONMeanings[number].partOfSpeech
                
                if JSONMeanings[number].definitions.count == 1 {
                    cell.definitionLabel1.text = JSONMeanings[number].definitions[0].definition
                } else {
//                    var arrayOfDefinitions: [String] = []
                    cell.definitionLabel1.text = String()
                    JSONMeanings[number].definitions.forEach({
                        cell.definitionLabel1.text?.append("\n\($0.definition)")
                    })
                }
                
//            case 1:
//                cell.partOfSpeechLabel2.text = JSONMeanings[number].partOfSpeech
//
//                if JSONMeanings[number].definitions.count == 1 {
//                    cell.definitionLabel2.text = JSONMeanings[number].definitions[0].definition
//                } else {
//                    cell.definitionLabel2.text = String()
//                    JSONMeanings[number].definitions.forEach({
//                        cell.definitionLabel2.text?.append("\n\($0.definition)")
//                    })
//                }
//
//            case 2:
//                cell.partOfSpeechLabel3.text = JSONMeanings[number].partOfSpeech
//
//                if JSONMeanings[number].definitions.count == 1 {
//                    cell.definitionLabel3.text = JSONMeanings[number].definitions[0].definition
//                } else {
//                    cell.definitionLabel3.text = String()
//                    JSONMeanings[number].definitions.forEach({
//                        cell.definitionLabel3.text?.append("\n\($0.definition)")
//                    })
//                }
                
            default:
                break
            }
        }
        return cell
    }
    
    //only available if we have UICollectionViewDelegateFlowLayout protocol
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-10, height: 180)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = JSONTopResult[indexPath.item]
        let wdController = WordDetailsController()
        
        wdController.word = item.word
        wdController.phonetic = item.phonetic ?? "no phonetics"
        
        self.JSONMeanings = item.meanings
        let count = 0...JSONMeanings.count-1
        for number in count {
            switch number {
            case 0:
                wdController.partOfSpeech1 = JSONMeanings[number].partOfSpeech!
                
                if JSONMeanings[number].definitions.count == 1 {
                    wdController.definition1 = JSONMeanings[number].definitions[0].definition
                } else {
                    //                    var arrayOfDefinitions: [String] = []
                    wdController.definition1 = String()
                    JSONMeanings[number].definitions.forEach({
                        wdController.definition1.append("\n\($0.definition)")
                    })
                }
                
            case 1:
                wdController.partOfSpeech2 = JSONMeanings[number].partOfSpeech!
                
                if JSONMeanings[number].definitions.count == 1 {
                    wdController.definition2 = JSONMeanings[number].definitions[0].definition
                } else {
                    wdController.definition2 = String()
                    JSONMeanings[number].definitions.forEach({
                        wdController.definition2.append("\n\($0.definition)")
                    })
                }
                
            case 2:
                wdController.partOfSpeech3 = JSONMeanings[number].partOfSpeech!
                
                if JSONMeanings[number].definitions.count == 1 {
                    wdController.definition3 = JSONMeanings[number].definitions[0].definition
                } else {
                    wdController.definition3 = String()
                    JSONMeanings[number].definitions.forEach({
                        wdController.definition3.append("\n\($0.definition)")
                    })
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
