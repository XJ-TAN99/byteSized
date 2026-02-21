//
//  CurrencyService.swift
//  currency_converter
//
//  Created by Tan Xin Jie on 21/2/26.
//

import Foundation

enum CurrencyServiceError: LocalizedError {
    case unsupportedCurrency

    var errorDescription: String? {
        switch self {
        case .unsupportedCurrency:
            return "The selected currency is not currently supported."
        }
    }
}

protocol CurrencyServicing {
    func fetchConversionRate(for currencyCode: String) async throws -> Decimal
}

class CurrencyService: CurrencyServicing {
    func fetchConversionRate(for currencyCode: String) async throws -> Decimal {
        try await Task.sleep(nanoseconds: 100_000_000)
        
        switch currencyCode {
        case "USD":
            return 0.79
        case "JPY":
            return 122.41
        case "VND":
            return 20497.33
        default:
            throw CurrencyServiceError.unsupportedCurrency
        }
    }
}
