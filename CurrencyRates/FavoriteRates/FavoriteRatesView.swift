//
//  FavoriteRatesView.swift
//  CurrencyRates
//
//  Created by Eduard Galchenko on 08.11.24.
//

import SwiftUI

struct FavoriteRatesView: View {
    @ObservedObject var viewModel: CurrencyListViewModel

    var body: some View {
        List(viewModel.favoriteRates, id: \.symbol) { rate in
            HStack {
                Text(rate.symbol)
                    .font(.headline)
                Spacer()
                Text(String(format: "%.2f", rate.rate))
                    .font(.subheadline)
            }
        }
    }
}
