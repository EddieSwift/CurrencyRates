//
//  CurrencyListViewModel.swift
//  CurrencyRates
//
//  Created by Eduard Galchenko on 07.11.24.
//

import SwiftUI
import Combine

class CurrencyListViewModel: ObservableObject {
    @Published var currencyRates: [CurrencyRate] = []
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        if !fetchExchangeRates() { // Attempt to load saved data if no network
            loadSavedRates()
        }
        loadFavorites()
    }

    func fetchExchangeRates() -> Bool {
        if !NetworkManager.shared.isNetworkAvailable {
            errorMessage = "No internet connection. Showing saved data."
            return false
        }
        
        NetworkManager.shared.fetchExchangeRates { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let rates):
                    self?.currencyRates = rates.map { rate in
                        var rate = rate
                        rate.isFavorite = self?.isFavorite(symbol: rate.symbol) ?? false
                        return rate
                    }
                    self?.errorMessage = nil
                    self?.saveRates(rates)
                case .failure(let error):
                    self?.currencyRates = []
                    self?.errorMessage = error.localizedDescription
                    self?.loadSavedRates()
                }
            }
        }
        return true
    }

    func toggleFavorite(for rate: CurrencyRate) {
        if let index = currencyRates.firstIndex(where: { $0.symbol == rate.symbol }) {
            currencyRates[index].isFavorite.toggle()
            saveFavorites()
        }
    }

    var favoriteRates: [CurrencyRate] {
        currencyRates.filter { $0.isFavorite }
    }

    // MARK: - Persistence
    private func saveFavorites() {
        let favoriteSymbols = currencyRates.filter { $0.isFavorite }.map { $0.symbol }
        UserDefaults.standard.set(favoriteSymbols, forKey: "favoriteRates")
    }
    
    private func loadFavorites() {
        let favoriteSymbols = UserDefaults.standard.array(forKey: "favoriteRates") as? [String] ?? []
        for i in currencyRates.indices {
            currencyRates[i].isFavorite = favoriteSymbols.contains(currencyRates[i].symbol)
        }
    }

    private func isFavorite(symbol: String) -> Bool {
        let favoriteSymbols = UserDefaults.standard.array(forKey: "favoriteRates") as? [String] ?? []
        return favoriteSymbols.contains(symbol)
    }
    
    private func saveRates(_ rates: [CurrencyRate]) {
        do {
            let encodedData = try JSONEncoder().encode(rates)
            UserDefaults.standard.set(encodedData, forKey: "savedRates")
        } catch {
            print("Failed to save rates: \(error)")
        }
    }

    private func loadSavedRates() {
        guard let savedData = UserDefaults.standard.data(forKey: "savedRates") else { return }
        
        do {
            let decodedRates = try JSONDecoder().decode([CurrencyRate].self, from: savedData)
            self.currencyRates = decodedRates
        } catch {
            print("Failed to load saved rates: \(error)")
        }
    }
}
