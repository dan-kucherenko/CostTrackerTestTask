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
    let usd: Currency
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

struct Currency: Codable {
    let rate: String
}
