//
//  ApiBitcoinManager.swift
//  CostTrackerTestTask
//
//  Created by Daniil on 01.06.2024.
//

import Foundation

class ApiBitcoinManager {
    static let shared = ApiBitcoinManager()
    private let url = "https://api.coindesk.com/v1/bpi/currentprice.json"
    
    private init(){}
    
    func getBitcoinRate() async throws -> String {
        guard let url = URL(string: url) else {
            throw ApiErrors.invalidUrl("Invalid URL")
        }
    
        do {
            let (btcRateResponse, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(ApiResponse.self, from: btcRateResponse)
                return decodedData.bpi.usd.rate
            } catch {
                throw ApiErrors.decodingError("Error decoding the data")
            }
        } catch {
            throw ApiErrors.serverError("Error getting data from api")
        }
    }
}

