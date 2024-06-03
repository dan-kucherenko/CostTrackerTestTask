//
//  DatabaseManager.swift
//  CostTrackerTestTask
//
//  Created by Daniil on 02.06.2024.
//

import Foundation

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let context = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    
    func fetchAll<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        if T.self == Transaction.self {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        }
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            return fetchedObjects
        } catch {
            print("Failed to fetch \(entityName): \(error.localizedDescription)")
            return []
        }
    }
    
    func saveContext() {
        try? context.save()
    }
    
    func saveObject<T: NSManagedObject>(_ object: T) {
        do {
            try context.save()
        } catch {
            print("Failed to save object: \(error.localizedDescription)")
        }
    }
    
    func fetchBalance() -> Double? {
         let fetchRequest: NSFetchRequest<Balance> = Balance.fetchRequest()
         
         do {
             if let balance = try context.fetch(fetchRequest).first {
                 return balance.bitcoins
             } else {
                 print("No balance found")
                 return nil
             }
         } catch {
             print("Failed to fetch balance: \(error.localizedDescription)")
             return nil
         }
     }
    
    func updateBalance(by bitcoins: Double) -> Bool {
        let fetchRequest: NSFetchRequest<Balance> = Balance.fetchRequest()
        
        do {
            if let existingBalance = try context.fetch(fetchRequest).first {
                existingBalance.bitcoins += bitcoins
                try context.save()
                return true
            } else {
                let balance = Balance(context: context)
                balance.bitcoins = bitcoins
                print("No balance found to update")
                return false
            }
        } catch {
            print("Failed to update balance: \(error.localizedDescription)")
            return false
        }
    }
}

