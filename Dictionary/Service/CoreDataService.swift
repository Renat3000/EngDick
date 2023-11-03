//
//  CoreDataService.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 02.11.2023.
//

import Foundation
import UIKit

class CoreDataService {
    // CoreData functions
    
    static let shared = CoreDataService() //singleton object?
    private init() {}
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllItems() -> [FavoritesItem] {
        var models = [FavoritesItem]()
        do {
            models = try context.fetch(FavoritesItem.fetchRequest())
            
            DispatchQueue.main.async {
//                FavoritesController().tableView.reloadData()
            }
        } catch {
            
        }
        return models
    }
    
    func createItem(name: String, itemCell: Int16){
        let newItem = FavoritesItem(context: context)
        newItem.word = name
        newItem.itemCell = itemCell
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
        print(newItem)
    }
    
    func deleteItem(item: FavoritesItem) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
}
