//
//  CoreDataService.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 02.11.2023.
//

import UIKit
import CoreData

class CoreDataService {
    // MARK: CoreData functions
    
    static let shared = CoreDataService() //singleton object?
    private let context: NSManagedObjectContext
    private init() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        context = appDelegate.persistentContainer.viewContext
    }
    
    func getAllItems() -> [FavoritesItem] {
//        var models = [FavoritesItem]()
        do {
            return try context.fetch(FavoritesItem.fetchRequest())
            
//            DispatchQueue.main.async {
//                FavoritesController().tableView.reloadData()
//            }
        } catch {
            print("Error fetching items from Core Data: \(error)")
            return []
        }
    }
    
    func createItem(name: String){
        let newItem = FavoritesItem(context: context)
        newItem.word = name
        newItem.numberrOfRepetitions = 1.0
        newItem.easinessFactor = 2.5
        newItem.dateOfCreation = Date()
        newItem.dateOfLastReview = Date()
        newItem.latestInterval = 1.0
        
        do {
            try context.save()
        } catch {
            print("Error creating item in Core Data: \(error)")
        }
    }
    
    func deleteItem(item: FavoritesItem) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("Error deleting item in Core Data: \(error)")
        }
    }
    
    func updateItem(item: FavoritesItem, newNumberOfRepetitions: Double, newEasinessFactor: Double) {
        item.numberrOfRepetitions = newNumberOfRepetitions
        item.easinessFactor = newEasinessFactor
        item.dateOfLastReview = Date()

        do {
            try context.save()
        } catch {
            print("Error updating item in Core Data: \(error)")
        }
    }
    
    func updateItemInterval(item: FavoritesItem, newInterval: Double) {
        item.latestInterval = newInterval

        do {
            try context.save()
        } catch {
            print("Error updating item in Core Data: \(error)")
        }
    }

    func deleteItem(withName name: String) {
        let fetchRequest: NSFetchRequest<FavoritesItem> = FavoritesItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "word == %@", name)

        do {
            let items = try context.fetch(fetchRequest)
            for item in items {
                context.delete(item)
            }
            try context.save()
        } catch {
            print("Error deleting item from Core Data: \(error)")
        }
    }

}
