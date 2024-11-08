//
//  CurrencyListTabView.swift
//  CurrencyRates
//
//  Created by Eduard Galchenko on 08.11.24.
//

import SwiftUI

struct CurrencyListTabView: View {
    @StateObject private var viewModel = CurrencyListViewModel()

    var body: some View {
        TabView {
            CurrencyListView(viewModel: viewModel)
                .tabItem {
                    Label("Rates", systemImage: "list.dash")
                }
            
            FavoriteRatesView(viewModel: viewModel)
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
        }
    }
}

#Preview {
    CurrencyListTabView()
}
