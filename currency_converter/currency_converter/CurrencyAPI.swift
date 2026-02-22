//
//  CurrencyAPI.swift
//  currency_converter
//
//  Created by Tan Xin Jie on 22/2/26.
//

import Foundation

class CurrencyAPI {
    private let baseURL = URL(string: "https://api.exchangerate.host")!
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getConversionRate(from: String) async throws -> [String : Decimal] {
        var components = URLComponents(
            url: baseURL.appendingPathComponent("latest"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [
            URLQueryItem(name: "base", value: from),
        ]
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        guard let decoded = try JSONDecoder().decode(LatestRatesResponse?.self, from: data) else {
            throw URLError(.badServerResponse)
        }
        
        return decoded.rates
    }
}

struct LatestRatesResponse: Decodable {
    let base: String
    let rates: [String: Decimal]
}
