//
//  CurrencyRate.swift
//  CurrencyRates
//
//  Created by Eduard Galchenko on 06.11.24.
//

import Foundation

struct CurrencyRate: Decodable {
    let symbol: String
    let rate: Double
}

struct CoinlayerResponse: Decodable {
    let success: Bool
    let terms: String?
    let privacy: String?
    let timestamp: Int?
    let target: String?
    let rates: [String: Double]?
}
