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
    
    fileprivate var JSONResult = [Meaning]()
    fileprivate var JSONTopResult = [JSONStruct]()
    fileprivate func fetchDictionary(searchTerm: String) {
        //get back json-fetched data from the Service file
        
        Service.shared.fetchJSON(searchTerm: searchTerm) { (JSONStruct, err)  in
            
            if let err = err {
                print("failed to fetch dictionary entries", err)
                return
            }
            
            self.JSONResult = JSONStruct[0].meanings
            self.JSONTopResult = JSONStruct
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return JSONResult.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DictionaryEntryCell

        let dictionaryEntryJSON = JSONResult[indexPath.item]
        cell.wordLabel.text = JSONTopResult[0].word
        cell.phoneticsLabel.text = JSONTopResult[0].phonetic
        cell.partOfSpeechLabel.text = dictionaryEntryJSON.partOfSpeech
        cell.definitionLabel.text = dictionaryEntryJSON.definitions[0].definition
        
        return cell
    }
    
    //only available if we have UICollectionViewDelegateFlowLayout protocol
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-10, height: 200)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          if let searchText = searchBar.text {
              fetchDictionary(searchTerm: searchText)
          }
          searchBar.resignFirstResponder() // to hide the keyboard
      }
}
