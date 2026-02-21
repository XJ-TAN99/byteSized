//
//  CurrencyCache.swift
//  currency_converter
//
//  Created by Tan Xin Jie on 21/2/26.
//

import Foundation

struct CurrencyCacheValue {
    let rate: Decimal
    let expiry: Date

    var isFresh: Bool {
        expiry > Date()
    }
}

final class CurrencyCache {
    private var cache: [Currency: CurrencyCacheValue] = [:]
    private let cacheDuration: TimeInterval

    init(cacheDuration: TimeInterval = 3) {
        self.cacheDuration = cacheDuration
    }

    func setCache(key: Currency, rate: Decimal) {
        let expiry = Date().addingTimeInterval(cacheDuration)
        cache[key] = CurrencyCacheValue(rate: rate, expiry: expiry)
    }

    func getCache(key: Currency) -> Decimal? {
        guard let cached = cache[key], cached.isFresh else {
            cache[key] = nil
            return nil
        }
        return cached.rate
    }

    func clearCache(for key: Currency) {
        cache[key] = nil
    }

    func clearAll() {
        cache.removeAll()
    }
}
