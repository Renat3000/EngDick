//
//  ResultsTableController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 11.11.2023.
//

import UIKit

class ResultsTableController: UITableViewController {

    var searchOptions: [String] = []
    var filteredSearchOptions: [String] = []
    static let wordCellIdentifier = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    weak var suggestedSearchDelegate: SuggestedSearch?
    
    static let suggestedSearches = [
        NSLocalizedString("Red Flowers", comment: ""),
        NSLocalizedString("Green Flowers", comment: ""),
        NSLocalizedString("Blue Flowers", comment: "")
    ]
    
    // search suggestions from english.txt file
    private func loadSuggestions() {
          if let path = Bundle.main.path(forResource: "english", ofType: "txt"),
             let contents = try? String(contentsOfFile: path) {
              searchOptions = contents.components(separatedBy: .newlines)
          }
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultsTableController.wordCellIdentifier, for: indexPath)
//        cell.textLabel?.text = filteredSearchOptions[indexPath.row]
        return cell
    }

    // MARK: - UITableViewDelegate

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedSuggestion = filteredSearchOptions[indexPath.row]
//        print("Selected suggestion: \(selectedSuggestion)")
//
//        // fire the api
//    }
}

protocol SuggestedSearch: AnyObject {
    // A suggested search was selected; inform our delegate that the selected search token was selected.
    func didSelectSuggestedSearch(token: UISearchToken)
    
    // A product was selected; inform our delgeate that a product was selected to view.
//    func didSelectProduct(product: Product)
}
