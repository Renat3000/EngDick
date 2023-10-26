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
        
        cell.partOfSpeechLabel.text = JSONTopResult[indexPath.item].meanings[0].partOfSpeech
        
        self.JSONMeanings = JSONTopResult[indexPath.item].meanings
        cell.definitionLabel.text = JSONMeanings[0].definitions[0].definition
        JSONMeanings[0].definitions.forEach({
            if cell.definitionLabel.text != $0.definition {
                cell.definitionLabel.text?.append("\n\($0.definition)")
            }
        })
        return cell
    }
    
    //only available if we have UICollectionViewDelegateFlowLayout protocol
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-10, height: 180)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = JSONTopResult[indexPath.item]
        let wdController = WordDetailsController()
        self.present(wdController, animated: true)
        wdController.wordLabel.text = item.word
        wdController.phoneticsLabel.text = item.phonetic
        wdController.partOfSpeechLabel.text = item.meanings[0].partOfSpeech
        wdController.definitionLabel.text = item.meanings[0].definitions[0].definition
        
        JSONMeanings[0].definitions.forEach({
            if wdController.definitionLabel.text != $0.definition {
                wdController.definitionLabel.text?.append("\n\($0.definition)")
            }
        })
        print(item)
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
