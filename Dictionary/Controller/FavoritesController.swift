//
//  FavoritesController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 18.10.2023.
//

import UIKit

class FavoritesController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let coreDataService = CoreDataService.shared
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private var models = CoreDataService.shared.getAllItems()
    private var theCell: Int?
    var selectedCoreDataItem: FavoritesItem?
    
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
            if let cellNumber = theCell {
                let selectedItem = self.JSONTopResult[cellNumber]
                
                DispatchQueue.main.async { [self] in
                    let wdController = WordDetailsController(item: selectedItem)
                    self.navigationController?.pushViewController(wdController, animated: true)
                }
            }
        }
    }

    fileprivate var JSONMeanings = [Meaning]()
    fileprivate func fetchDictionary(searchTerm: String) {
        //get back json-fetched data from the JSONService file
        print("firing off request, just wait!")
        JSONService.shared.fetchJSON(searchTerm: searchTerm) { (JSONStruct, err)  in
            
            
            if let err = err {
                print("failed to fetch dictionary entries", err)
                return
            }
            
            self.JSONTopResult = JSONStruct
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCoreDataItem = models[indexPath.row]
        if let cell = selectedCoreDataItem?.itemCell {
            theCell = Int(cell)
        }
        if let word = selectedCoreDataItem?.word {
            fetchDictionary(searchTerm: word)
        }
    }
}
