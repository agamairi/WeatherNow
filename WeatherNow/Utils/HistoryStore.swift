//
//  HistoryStore.swift
//  WeatherNow
//
//  Created by Agam Airi on 2025-08-20.
//

import Foundation

struct HistoryStore {
    private static let key = "weather_search_history_v1"
    
    static func save(_ items: [String]) {
        UserDefaults.standard.set(items, forKey: key)
    }
    static func load() -> [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }
    static func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
