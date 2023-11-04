//
//  FavoritesController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 18.10.2023.
//

import UIKit

class FavoritesController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let coreDataService = CoreDataService.shared
    let wdController = WordDetailsController()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    private var models = CoreDataService.shared.getAllItems()
    var selectedCoreDataItem: FavoritesItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            
            func setupDefinitions(wdPartOfSpeech: inout String, wdDefinition: inout NSMutableAttributedString, number: Int) {
                wdPartOfSpeech = JSONMeanings[number].partOfSpeech ?? "no info"
                let lineBreak = NSAttributedString(string: "\n")
                
                if JSONMeanings[number].definitions.count == 1 {
                    wdDefinition = NSMutableAttributedString(string: JSONMeanings[number].definitions[0].definition)
                    
                    if let example = JSONMeanings[number].definitions[0].example {
                        let exampleText = NSAttributedString(string: " \(example)", attributes: [.font: UIFont.italicSystemFont(ofSize: 18)])
                        wdDefinition.append(exampleText)
                    }
                } else {
                    for (index, definition) in JSONMeanings[number].definitions.enumerated() {
                        let content = "\(index + 1). \(definition.definition)"
                        let contentText = NSAttributedString(string: content, attributes: [.font: UIFont.systemFont(ofSize: 18)])
                        wdDefinition.append(contentText)
                        
                        if let example = definition.example {
                            let exampleText = NSAttributedString(string: " \(example)", attributes: [.font: UIFont.italicSystemFont(ofSize: 18)])
                            wdDefinition.append(exampleText)
                        }
                        wdDefinition.append(lineBreak)
                    }
                }
            }
            
            if let coreDataItem = selectedCoreDataItem {
                let path = Int(coreDataItem.itemCell)
                let item = self.JSONTopResult[path]
                self.JSONMeanings = JSONTopResult[path].meanings
                
                let count = 0...self.JSONMeanings.count-1
                
                DispatchQueue.main.async { [self] in
                    wdController.word = item.word
                    wdController.phonetic = item.phonetic ?? "no phonetics"
                    wdController.isBookmarked = true
                    //                wdController.coreDataItem = self.coreDataItem
                    wdController.itemWasAtCell = coreDataItem.itemCell
                    for number in count {
                        switch number {
                        case 0:
                            setupDefinitions(wdPartOfSpeech: &wdController.partOfSpeech1, wdDefinition: &wdController.definition1, number: number)
                        case 1:
                            setupDefinitions(wdPartOfSpeech: &wdController.partOfSpeech2, wdDefinition: &wdController.definition2, number: number)
                        case 2:
                            setupDefinitions(wdPartOfSpeech: &wdController.partOfSpeech3, wdDefinition: &wdController.definition3, number: number)
                        default:
                            break
                        }
                    }
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
        if let word = selectedCoreDataItem?.word {
            fetchDictionary(searchTerm: word)
        }
    }
}
