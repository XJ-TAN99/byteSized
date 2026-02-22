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

struct LatestRatesResponse: Decodable {
    let base: String
    let rates: [String: Decimal]
}

protocol CurrencyServicing {
    var baseURL: URL { get }
    var session: URLSession { get }
    
    init(session: URLSession)
    
    func fetchConversionRate(from: String, to: String) async throws -> Decimal
}

final class CurrencyService: CurrencyServicing {
    let baseURL = URL(string: "https://api.exchangerate.host")!
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchConversionRate(from: String, to: String) async throws -> Decimal {
        var components = URLComponents(
            url: baseURL.appendingPathComponent("latest"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [
            URLQueryItem(name: "base", value: from),
            URLQueryItem(name: "symbols", value: to)
        ]
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(LatestRatesResponse.self, from: data)
        
        guard let rate = decoded.rates[to] else {
            throw NSError(domain: "RateMissing", code: 0)
        }
        
        return rate
    }
}
