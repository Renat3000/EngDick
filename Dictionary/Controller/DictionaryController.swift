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
        // Do any additional setup after loading the view.
//        view.addSubview(dictionaryView)
//        dictionaryView.fillSuperview()
        dictionaryView.searchBar.delegate = self
        collectionView.register(DictionaryEntryCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
//        cell.backgroundColor = .red
        
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
//                dictionaryView.testTextLabel.text = "\(searchResult[0].meanings)"
                print(searchResult.forEach(
                    {
                        print($0.word, $0.meanings.forEach(
                            {
                                print($0.definitions.forEach(
                                    {
                                        print($0.definition)
                                    }
                                )
                                )
                            }
                        )
                        )
                    }
                )
                )
            } catch let jsonErr {
                print("failed to decode", jsonErr)
            }
            
            
            
        }.resume() //fire the request
    }

}

