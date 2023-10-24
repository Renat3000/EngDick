//
//  FavoritesController.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 18.10.2023.
//

import UIKit

class FavoritesController: UIViewController, UITableViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [FavoritesItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "CoreData Test List"
    }

    // CoreData functions
    
    func getAllItems(){
        do {
            models = try context.fetch(FavoritesItem.fetchRequest())
            
        } catch {
            
        }
    }
    
    func createItem(name: String){
        let newItem = FavoritesItem(context: context)
        newItem.word = name
        newItem.dateOfCreation = Date()
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
        }
    }
    
    func deleteItem(item: FavoritesItem) {
        context.delete(item)
        
        do {
            try context.save()
        }
        catch {
            
        }
    }
    
    func updateItem(item: FavoritesItem, newName: String) {
        item.word = newName
        
        do {
            try context.save()
        }
        catch {
            
        }
    }
}
