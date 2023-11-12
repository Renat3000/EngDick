//
//  DictionaryController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 18.10.2023.
//

import UIKit

class DictionaryController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    fileprivate let cellId = "dictionaryCell"
    var searchController = UISearchController(searchResultsController: nil)
    private var searchOptions: [String] = []
    private var filteredSearchOptions: [String] = []
    
    private let suggestionsTableView: UITableView = {
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "suggestionCell")

            return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        view.addSubview(suggestionsTableView)
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        
        loadSearchOptions()
        loadSearchBar()
        
        suggestionsTableView.frame = view.bounds
        suggestionsTableView.backgroundColor = .systemGray4
        suggestionsTableView.reloadData()
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
        //get back json-fetched data from the JSONService file
        print("firing off request, just wait!")
        JSONService.shared.fetchJSON(searchTerm: searchTerm) { (JSONStruct, err)  in
            
            if let err = err {
                print("failed to fetch dictionary entries", err)
                self.displayErrorAlert(message: "failed to fetch dictionary entries") // actually we can just use err.localizedDescription
                return
            }
            
            self.JSONTopResult = JSONStruct
            
            DispatchQueue.main.async {

            }
        }
    }
    
    //error message in case we don't have the word in the dictionary or there's no internet connection
    func displayErrorAlert(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // search suggestions from english.txt file
    private func loadSearchOptions() {
          if let path = Bundle.main.path(forResource: "english", ofType: "txt"),
             let contents = try? String(contentsOfFile: path) {
              searchOptions = contents.components(separatedBy: .newlines)
          }
    }
 
    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            // Фильтруем варианты поиска на основе введенного текста
            filteredSearchOptions = searchOptions.filter { $0.lowercased().contains(searchText.lowercased()) }
            // Показываем таблицу с подсказками
//            suggestionsTableView.isHidden = false
            suggestionsTableView.reloadData()
        } else {
            // Если текст поиска пуст, скрываем таблицу
            suggestionsTableView.isHidden = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          if let searchText = searchBar.text {
              fetchDictionary(searchTerm: searchText.replacingOccurrences(of: " ", with: "%20"))
          }
          searchBar.resignFirstResponder() // to hide the keyboard
    }
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchOptions.count-1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell", for: indexPath)
        cell.textLabel?.text = searchOptions[indexPath.row]
        cell.backgroundColor = .systemGray4
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSuggestion = searchOptions[indexPath.row]
        print("Selected suggestion: \(selectedSuggestion)")
        
        // fire the api
        fetchDictionary(searchTerm: selectedSuggestion.replacingOccurrences(of: " ", with: "%20"))
    }
    
}

//    fileprivate let cellId = "dictionaryCell"
//    fileprivate var searchController = UISearchController(searchResultsController: nil)
    
//    init() {
////        super.init(collectionViewLayout: UICollectionViewFlowLayout())
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

//  if we use collectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return JSONTopResult.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DictionaryEntryPreviewCell
//
//        cell.wordLabel.text = JSONTopResult[indexPath.item].word
//        cell.phoneticsLabel.text = JSONTopResult[indexPath.item].phonetic
//
//        self.JSONMeanings = JSONTopResult[indexPath.item].meanings
//        cell.partOfSpeechLabel1.text = JSONMeanings[0].partOfSpeech
//
//        cell.definitionLabel1.text = String()
//        cell.definitionLabel1.text = JSONMeanings[0].definitions[0].definition
//
//        if JSONMeanings[0].definitions.count > 1 {
//            cell.definitionLabel1.text?.append("..")
//        }
//
//        return cell
//    }
    
    //only available if we have UICollectionViewDelegateFlowLayout protocol
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width-10, height: 120)
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let selectedItem = JSONTopResult[indexPath.item]
//        let wdController = WordDetailsController(item: selectedItem, isBookmarked: false)
//        navigationController?.pushViewController(wdController, animated: true)
//    }
