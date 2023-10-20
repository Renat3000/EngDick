//
//  ViewController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 18.10.2023.
//

import UIKit

class DictionaryController: UIViewController, UISearchBarDelegate {

    let dictionaryView: DictionaryView
    
    init() {
        dictionaryView = DictionaryView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(dictionaryView)
        dictionaryView.fillSuperview()
        dictionaryView.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          if let searchText = searchBar.text {
              dictionaryView.testTextLabel.text = searchText
              fetchDictionary(searchTerm: searchText)
          }
          searchBar.resignFirstResponder() // to hide the keyboard
      }
    
    fileprivate func fetchDictionary(searchTerm: String) {
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(searchTerm)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, resp, err in
            
            if let err = err {
                print("failed to fetch")
                return
            }
            
            // success
            guard let data = data else { return }
            
            do {
                let searchResult = try
                    JSONDecoder().decode([JSONStruct].self, from: data)
                print(searchResult)
            } catch let jsonErr {
                print("failed to decode", jsonErr)
            }
            
            
            
        }.resume() //fire the request
    }

}

