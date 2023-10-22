//
//  ViewController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 18.10.2023.
//

import UIKit

class DictionaryController: UICollectionViewController, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {

    let dictionaryView: DictionaryView
    fileprivate let cellId = "dictionaryCell"
  
    init() {
        dictionaryView = DictionaryView()
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDictionary(searchTerm: "sir")
//        view.addSubview(dictionaryView)
//        dictionaryView.fillSuperview()
        dictionaryView.searchBar.delegate = self
        collectionView.register(DictionaryEntryCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate var JSONResult = [Meaning]()
    fileprivate var JSONTopResult = [JSONStruct]()
    fileprivate func fetchDictionary(searchTerm: String) {
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(searchTerm)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, resp, err in
            
            if let err = err {
                print("failed to fetch", err)
                return
            }
            
            // success
            guard let data = data else { return }
            
            do {
                let searchResult = try
                    JSONDecoder().decode([JSONStruct].self, from: data)
                self.JSONResult = searchResult[0].meanings
                self.JSONTopResult = searchResult
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                print(searchResult)
//                dictionaryView.testTextLabel.text = "\(searchResult[0].meanings)"
//                print(searchResult.forEach(
//                    {
//                        print($0.word, $0.meanings.forEach(
//                            {
//                                print($0.definitions.forEach(
//                                    {
//                                        print($0.definition)
//                                    }
//                                )
//                                )
//                            }
//                        )
//                        )
//                    }
//                )
//                )
            } catch let jsonErr {
                print("failed to decode", jsonErr)
            }
            
        }.resume() //fire the request
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return JSONResult.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DictionaryEntryCell
//        cell.backgroundColor = .red
        let dictionaryEntryJSON = JSONResult[indexPath.item]
        let definitionsJSON = JSONResult[indexPath.item].definitions
        cell.wordLabel.text = JSONTopResult[0].word
        cell.phoneticsLabel.text = JSONTopResult[0].phonetic
        cell.partOfSpeechLabel.text = dictionaryEntryJSON.partOfSpeech
        cell.definitionLabel.text = dictionaryEntryJSON.definitions[0].definition
        return cell
    }
    
    //only available if we have UICollectionViewDelegateFlowLayout protocol
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width-10, height: 250)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          if let searchText = searchBar.text {
              fetchDictionary(searchTerm: searchText)
          }
          searchBar.resignFirstResponder() // to hide the keyboard
      }

}

