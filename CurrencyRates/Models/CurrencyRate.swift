//
//  CurrencyRate.swift
//  CurrencyRates
//
//  Created by Eduard Galchenko on 06.11.24.
//

import Foundation

struct CurrencyRate: Decodable, Identifiable {
    var id = UUID()
    let symbol: String
    let rate: Double
    var isFavorite: Bool = false
}

struct CoinlayerResponse: Decodable {
    let success: Bool
    let terms: String?
    let privacy: String?
    let timestamp: Int?
    let target: String?
    let rates: [String: Double]?
}
