//
//  ApiError.swift
//  CostTrackerTestTask
//
//  Created by Daniil on 01.06.2024.
//

import Foundation

enum ApiErrors: Error {
    case invalidUrl(String)
    case serverError(String)
    case decodingError(String)
    case unexpectedError
    
    var errorDescription: String? {
        switch self {
        case .serverError(let message), .decodingError(let message):
            return message
        case .unexpectedError:
            return "An unexpected error occurred"
        case .invalidUrl:
            return "Invalid URL"
        }
    }
}
