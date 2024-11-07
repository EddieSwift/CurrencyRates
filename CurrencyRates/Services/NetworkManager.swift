//
//  NetworkManager.swift
//  CurrencyRates
//
//  Created by Eduard Galchenko on 06.11.24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func fetchExchangeRates(completion: @escaping (Result<[CurrencyRate], Error>) -> Void) {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else { return }
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "access_key", value: apiKey)
        ]

        guard let url = urlComponents.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            // Decode the JSON response
            do {
                let decodedResponse = try JSONDecoder().decode(CoinlayerResponse.self, from: data)
                
                // Check if the response was successful
                guard decodedResponse.success, let rates = decodedResponse.rates else {
                    completion(.failure(NetworkError.apiFailure))
                    return
                }

                // Map rates dictionary to CurrencyRate array
                let currencyRates = rates.map { CurrencyRate(symbol: $0.key, rate: $0.value) }
                
                // Return the list of currency rates
                completion(.success(currencyRates))
                
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// NetworkError enum to handle different error cases
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case apiFailure

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .invalidResponse:
            return "The server response was invalid."
        case .apiFailure:
            return "Failed to retrieve data from the API."
        }
    }
}
