//
//  CurrencyService.swift
//  currency_converter
//
//  Created by Tan Xin Jie on 21/2/26.
//

import Foundation

protocol CurrencyServicing {
    func fetchConversionRate(from base: Currency, to target: Currency) async throws -> Decimal
}

enum CurrencyServiceError: LocalizedError {
    case unsupportedCurrency    

    var errorDescription: String? {
        switch self {
        case .unsupportedCurrency:
            return "The selected currency is not currently supported."
        }
    }
}
 
final class CurrencyService: CurrencyServicing {
    private let api: CurrencyAPI
    private let cache: CurrencyCache
    
    init(api: CurrencyAPI, cache: CurrencyCache) {
        self.api = api
        self.cache = cache
    }

    func fetchConversionRate(from base: Currency, to target: Currency) async throws -> Decimal {
        // check cache
        if let cached = await cache.getCache(key: base, to: target.title) {
            return cached
        }
        
        // cache miss - network call
        let rates = try await api.getConversionRate(from: base.title)
        await cache.setCache(key: base, rates: rates)
        return rates[target.title]!
    }
}
