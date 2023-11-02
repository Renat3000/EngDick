//
//  FavoritesService.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 02.11.2023.
//

import Foundation
import UIKit

class FavoritesService {
    // CoreData functions
    
    static let shared = FavoritesService() //singleton object?
    private init() {}
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var models = [FavoritesItem]()
    
    func getAllItems(){
        do {
            models = try context.fetch(FavoritesItem.fetchRequest())
            
            DispatchQueue.main.async {
//                FavoritesController().tableView.reloadData()
            }
        } catch {
            
        }
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
