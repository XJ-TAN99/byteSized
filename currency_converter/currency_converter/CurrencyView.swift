//
//  ContentView.swift
//  currency_converter
//
//  Created by Tan Xin Jie on 21/2/26.
//

import SwiftUI

struct CurrencyView: View {
    @State private var viewModel = CurrencyViewModel()
    
    var body: some View {
        VStack (alignment: .center) {
            HStack {
                TextField(
                    "Enter Amount",
                    text: $viewModel.amountField
                )
                .textFieldStyle(.roundedBorder)
                .padding()
                Text("SGD")
            }
            makeCurrencyList();
            Button {
                Task {
                    await viewModel.onConvertPress()
                }
            } label: {
                Label("Convert", systemImage: "arrow.down")
            }
            .disabled(!viewModel.isButtonEnabled)
            .padding()
            TextField(
                "...",
                text: $viewModel.convertedField
            )
            .disabled(true)
            .textFieldStyle(.roundedBorder)
            .padding()
        }
        .padding()
    }
}

extension CurrencyView {
    func makeCurrencyList() -> some View {
        Picker("Select Currency", selection: $viewModel.selectedCurrency) {
            ForEach(Currency.allCases) {
                Text($0.title)
            }
        }
        .pickerStyle(.menu)
        .padding()
    }
}

#Preview {
    CurrencyView()
}
