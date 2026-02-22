//
//  CurrencyCache.swift
//  currency_converter
//
//  Created by Tan Xin Jie on 21/2/26.
//

import Foundation

struct CurrencyCacheValue {
    let rates: [String : Decimal]
    let expiry: Date
}

actor CurrencyCache {
    private var cache: [Currency: CurrencyCacheValue] = [:]
    private let cacheDuration: TimeInterval

    init(cacheDuration: TimeInterval = 3) {
        self.cacheDuration = cacheDuration
    }

    func setCache(key: Currency, rates: [String: Decimal]) {
        let expiry = Date().addingTimeInterval(cacheDuration)
        cache[key] = CurrencyCacheValue(rates: rates, expiry: expiry)
    }

    func getCache(key: Currency) -> [String: Decimal]? {
        guard let cached = cache[key], cached.expiry > Date() else {
            cache[key] = nil
            return nil
        }
        return cached.rates
    }
    
    func getCache(key: Currency, to target: String) -> Decimal? {
        guard let cached = cache[key], Date() < cached.expiry else {
            cache[key] = nil
            return nil
        }
        return cached.rates[target]
    }

    func clearCache(for key: Currency) {
        cache[key] = nil
    }

    func clearAll() {
        cache.removeAll()
    }
}
