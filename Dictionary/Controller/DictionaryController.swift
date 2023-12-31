//
//  DictionaryController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 18.10.2023.
//

import UIKit

class DictionaryController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var searchController = UISearchController(searchResultsController: nil)
    private var searchOptions: [String] = []
    private var filteredSearchOptions: [String] = []
    var filtered = false
    
    private let suggestionsTableView: UITableView = {
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "suggestionCell")

            return tableView
    }()
    
    deinit {
        print("no retain cycles / leaks in DictionaryController")
    }
    
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
    
    fileprivate func fetchDictionary(searchTerm: String) {
        //get back json-fetched data from the JSONService file
        print("firing off request, just wait!")
        JSONService.shared.fetchJSON(searchTerm: searchTerm) { (JSONStruct, err)  in
            
            if let err = err {
                print("failed to fetch dictionary entries", err)
                self.displayErrorAlert(message: "failed to fetch dictionary entries") // actually we can just use err.localizedDescription
                return
            }
            
            DispatchQueue.main.async {
                self.presentWordDetails(selectedItem: JSONStruct)
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
        filteredSearchOptions.removeAll()
        filteredSearchOptions = searchOptions.filter { $0.lowercased().starts(with: searchText.lowercased()) }
        suggestionsTableView.reloadData()
        filtered = true
        scrollToTop()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          if let searchText = searchBar.text {
              fetchDictionary(searchTerm: searchText.replacingOccurrences(of: " ", with: "%20"))
          }
          searchBar.resignFirstResponder() // to hide the keyboard
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredSearchOptions.removeAll()
        filtered = false
        suggestionsTableView.reloadData()
    }
    
    private func scrollToTop() {
        let topRow = IndexPath(row: 0, section: 0)
        suggestionsTableView.scrollToRow(at: topRow, at: .top, animated: true)
    }
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredSearchOptions.isEmpty {
            return filteredSearchOptions.count
        }
        return filtered ? 0 : searchOptions.count-1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell", for: indexPath)
        cell.backgroundColor = .systemGray4
        
        if !filteredSearchOptions.isEmpty {
            cell.textLabel?.text = filteredSearchOptions[indexPath.row]
        } else {
            cell.textLabel?.text = searchOptions[indexPath.row]
        }
        
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedSuggestion = String()
        if !filteredSearchOptions.isEmpty {
            selectedSuggestion = filteredSearchOptions[indexPath.row]
        } else {
            selectedSuggestion = searchOptions[indexPath.row]
        }
        
        print("Selected suggestion: \(selectedSuggestion)")
        
        // fire the api
        fetchDictionary(searchTerm: selectedSuggestion.replacingOccurrences(of: " ", with: "%20"))
  
    }
    
    func presentWordDetails(selectedItem: [JSONStruct]) {
        let wdController = WordDetailsController(items: selectedItem, isBookmarked: false)
        navigationController?.pushViewController(wdController, animated: true)
    }
}
