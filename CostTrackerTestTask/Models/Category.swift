//
//  Category.swift
//  CostTrackerTestTask
//
//  Created by Daniil on 02.06.2024.
//

import Foundation

enum Category: String, CaseIterable {
    case groceries
    case taxi
    case electronics
    case restaurant
    case other
    
    static func getCategoryBy(index: Int) -> Category? {
        let cases = Category.allCases
        guard index >= 0 && index < cases.count else {
            return nil
        }
        return cases[index]
    }
}
