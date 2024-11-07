//
//  CurrencyListView.swift
//  CurrencyRates
//
//  Created by Eduard Galchenko on 07.11.24.
//

import SwiftUI

struct CurrencyListView: View {
    @StateObject private var viewModel = CurrencyListViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                List(viewModel.currencyRates, id: \.symbol) { rate in
                    HStack {
                        Text(rate.symbol)
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.2f", rate.rate))
                            .font(.subheadline)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Currency Exchange Rates")
                .refreshable {
                    viewModel.fetchExchangeRates()
                }
            }
        }
    }
}

#Preview {
    CurrencyListView()
}
