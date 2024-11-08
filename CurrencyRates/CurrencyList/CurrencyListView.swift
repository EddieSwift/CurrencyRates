//
//  CurrencyListView.swift
//  CurrencyRates
//
//  Created by Eduard Galchenko on 07.11.24.
//

import SwiftUI

struct CurrencyListView: View {
    @ObservedObject var viewModel: CurrencyListViewModel

    var body: some View {
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
                    
                    Button(action: {
                        viewModel.toggleFavorite(for: rate)
                    }) {
                        Image(systemName: rate.isFavorite ? "star.fill" : "star")
                            .foregroundColor(rate.isFavorite ? .yellow : .gray)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                _ = viewModel.fetchExchangeRates()
            }
        }
    }
}
