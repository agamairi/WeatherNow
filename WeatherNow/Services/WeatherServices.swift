//
//  WeatherServices.swift
//  WeatherNow
//
//  Created by Agam Airi on 2025-08-20.
//

import Foundation

enum WeatherError: LocalizedError {
    case badURL
    case requestFailed
    case decodingError
    case noData
    case badStatus(Int)
    var errorDescription: String? {
    switch self {
            case .badURL: return "Bad URL"
            case .requestFailed: return "Request failed"
            case .decodingError: return "Failed parsing response"
            case .noData: return "No data returned"
            case .badStatus(let code): return "Bad status: \(code)"
        }
    }
}

final class WeatherServices {
    
    private let API_KEY = "MY_SECRET_API_KEY"
    
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        guard let cityEscaped = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw WeatherError.badURL
        }
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityEscaped)&appid=\(API_KEY)&units=metric"
        guard let url = URL(string: urlString) else {
            throw WeatherError.badURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        if let http = response as? HTTPURLResponse, http.statusCode != 200 {
            throw WeatherError.badStatus(http.statusCode)
        }
        do {
            return try JSONDecoder().decode(WeatherResponse.self, from: data)
        } catch {
            throw WeatherError.decodingError
        }
    }
}
