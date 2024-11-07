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
        fetchExchangeRates()
    }

    func fetchExchangeRates() {
        NetworkManager.shared.fetchExchangeRates { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let rates):
                    self?.currencyRates = rates
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.currencyRates = []
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
