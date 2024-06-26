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
    private let sortingKey = "date"
    
    func fetchBalance() -> Balance? {
         let fetchRequest: NSFetchRequest<Balance> = Balance.fetchRequest()
         
         do {
             if let balance = try context.fetch(fetchRequest).first {
                 return balance
             } else {
                 print("No balance found")
                 return nil
             }
         } catch {
             print("Failed to fetch balance: \(error.localizedDescription)")
             return nil
         }
     }
    
    func fetchTransactions(limit: Int, offset: Int) -> [Transaction]? {
            let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            fetchRequest.fetchLimit = limit
            fetchRequest.fetchOffset = offset
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortingKey, ascending: false)]
            
            do {
                let fetchedTransactions = try context.fetch(fetchRequest)
                return fetchedTransactions
            } catch {
                print("Failed to fetch transactions: \(error.localizedDescription)")
                return nil
            }
        }
    
    func updateBalance(by bitcoins: Double) {
        let fetchRequest: NSFetchRequest<Balance> = Balance.fetchRequest()
        
        do {
            if let existingBalance = try context.fetch(fetchRequest).first {
                existingBalance.bitcoins += bitcoins
                try context.save()
            } else {
                let balance = Balance(context: context)
                balance.bitcoins = bitcoins
                print("No balance found to update")
            }
        } catch {
            print("Failed to update balance: \(error.localizedDescription)")
        }
    }
    
    func saveContext() {
        try? context.save()
    }
}

