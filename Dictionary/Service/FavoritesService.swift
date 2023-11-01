//
//  FavoritesServices.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 01.11.2023.
//

import Foundation
import UIKit

class FavoritesService {
    private var models = [FavoritesItem]()
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // CoreData functions
    
    func getAllItems() -> [FavoritesItem] {
        do {
            models = try context.fetch(FavoritesItem.fetchRequest())
            //
            //            DispatchQueue.main.async {
            //                self.tableView.reloadData()
            //            }
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
            
        } catch {
            
        }
    }
    
    func deleteItem(item: FavoritesItem) {
        context.delete(item)
        
        do {
            try context.save()
            
        } catch {
            
        }
    }
}
