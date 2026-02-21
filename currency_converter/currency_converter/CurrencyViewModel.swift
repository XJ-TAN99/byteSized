//
//  ContentViewModel.swift
//  currency_converter
//
//  Created by Tan Xin Jie on 21/2/26.
//

import SwiftUI

@Observable
class CurrencyViewModel {
    var service: CurrencyServicing = CurrencyService()
    
    var amountField: String = "0.00"
    var conversionRate: Decimal = 0
    var convertedField: String = "0.00"
    var selectedCurrency: Currency = .usd
    var isButtonEnabled: Bool = true

    func convertCurrency() {
        guard let amountValue = Decimal(string: amountField), amountValue != 0 else { return }
        let convertedAmount = amountValue * conversionRate
        let formattedString = convertedAmount.formatted(.currency(code: selectedCurrency.title))
        convertedField = formattedString
    }
    
    func fetchConversionRate() async throws {
        do {
            let rate = try await service.fetchConversionRate(for: selectedCurrency.title)
            conversionRate = rate
        } catch {
            throw error
        }
    }
    
    func onConvertPress() async {
        isButtonEnabled = false
        defer { isButtonEnabled = true }
        
        do {
            try await fetchConversionRate()
            convertCurrency()
        } catch {
            print("Error fetching rate: \(error.localizedDescription)")
        }
    }
}

enum Currency: String, CaseIterable, Identifiable {
    case usd, jpy, vnd
    var id: Self { self }
    var title: String {
        switch self {
        case .usd: return "USD"
        case .jpy: return "JPY"
        case .vnd: return "VND"
        }
    }
}
