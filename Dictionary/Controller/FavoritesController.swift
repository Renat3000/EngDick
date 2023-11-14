//
//  FavoritesController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 18.10.2023.
//

import UIKit

class FavoritesController: UIViewController, UITableViewDelegate, UITableViewDataSource, passInfoToFavorites {

    let coreDataService = CoreDataService.shared
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private var models = CoreDataService.shared.getAllItems()
    lazy private var theCell = Int()
    lazy private var theCoreDataItem = FavoritesItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.backgroundColor = .systemGray4
        tableView.reloadData()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTap)) decided to ditch this function for a while
    }
    
    override func viewDidAppear(_ animated: Bool) {
        models = CoreDataService.shared.getAllItems()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let word = model.word {
            cell.textLabel?.text = "word:\(word), cell \(model.itemCell)"
        }
        cell.backgroundColor = .systemGray4
        return cell
    }
    
    fileprivate var JSONTopResult = [JSONStruct]() {
        didSet {
//                let selectedItem = self.JSONTopResult[theCell]
                let selectedItem = self.JSONTopResult
                DispatchQueue.main.async { [self] in
                    let wdController = WordDetailsController(items: selectedItem, isBookmarked: true)
                    wdController.wordDetailsDelegate = self
                    self.navigationController?.pushViewController(wdController, animated: true)
                }
        }
    } // need to study how I can get rid of it...
    
    fileprivate func fetchDictionary(searchTerm: String) {
        //get back json-fetched data from the JSONService file
        print("firing off request, just wait!")
        JSONService.shared.fetchJSON(searchTerm: searchTerm) { (JSONStruct, err)  in
            
            
            if let err = err {
                print("failed to fetch dictionary entries", err)
                return
            }
            
            self.JSONTopResult = JSONStruct
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCoreDataItem = models[indexPath.row]
        theCoreDataItem = selectedCoreDataItem
        theCell = Int(selectedCoreDataItem.itemCell)
        if let word = selectedCoreDataItem.word {
            fetchDictionary(searchTerm: word.replacingOccurrences(of: " ", with: "%20"))
        }
    }
    
    func deleteCurrentCoreDataEntry() {
        CoreDataService.shared.deleteItem(item: theCoreDataItem)
        
    }
    func refreshList() { // just for the test, this function isn't called
        print(models)
    }
}
