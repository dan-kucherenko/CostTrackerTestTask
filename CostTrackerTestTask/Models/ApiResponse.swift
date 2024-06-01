//
//  ApiResponse.swift
//  CostTrackerTestTask
//
//  Created by Daniil on 01.06.2024.
//

import Foundation

struct ApiResponse: Codable {
    let bpi: BpiResponse
}

struct BpiResponse: Codable {
    let USD: Currency
}

struct Currency: Codable {
    let rate: String
}
