//
//  ContentViewModel.swift
//  currency_converter
//
//  Created by Tan Xin Jie on 21/2/26.
//

import SwiftUI

@Observable
class CurrencyViewModel {
    private let service: CurrencyService
    
    var amountField: String = "0.00"
    var conversionRate: Decimal = 0
    var convertedField: String = "0.00"
    var selectedCurrency: Currency = .usd
    var isButtonEnabled: Bool = true
    
    init() {
        self.service = CurrencyService(api: CurrencyAPI(), cache: CurrencyCache())
    }

    func convertCurrency() {
        guard let amountValue = Decimal(string: amountField), amountValue != 0 else { return }
        let convertedAmount = amountValue * conversionRate
        let formattedString = convertedAmount.formatted(.currency(code: selectedCurrency.title))
        convertedField = formattedString
    }
    
    func onConvertButtonPress() async {
        isButtonEnabled = false
        defer { isButtonEnabled = true }
        
        do {
            conversionRate = try await service.fetchConversionRate(from: selectedCurrency, to: selectedCurrency)
            convertCurrency()
        } catch {
            print("Error fetching rate: \(error.localizedDescription)")
        }
    }
}

enum Currency: String, CaseIterable, Identifiable {
    case usd, eur, gbp, jpy
    var id: Self { self }
    var title: String {
        switch self {
        case .usd: return "USD"
        case .eur: return "EUR"
        case .gbp: return "GBP"
        case .jpy: return "JPY"
        }
    }
}
