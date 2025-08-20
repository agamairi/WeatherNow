//
//  WeatherResponse.swift
//  WeatherNow
//
//  Created by Agam Airi on 2025-08-20.
//

import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    
    struct Main: Codable {
        let temp: Double
    }
    struct Weather: Codable {
        let description: String
        let icon: String?
    }
}
