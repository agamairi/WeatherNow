//
//  WeatherViewModel.swift
//  WeatherNow
//
//  Created by Agam Airi on 2025-08-20.
//

import Foundation
import SwiftUI

@MainActor

final class WeatherViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var isLoading: Bool = false
    @Published var currentWeather: WeatherResponse?
    @Published var errorMessage: String?
    @Published var history: [String] = []
    @Published var showingErrorAlert: Bool = false
    
    private let service = WeatherServices()
    
    init() {
        history = HistoryStore.load()
    }
    
    func search() async {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let resp = try await service.fetchWeather(for: q)
            currentWeather = resp
            addToHistory(q)
        } catch let err as WeatherError {
            errorMessage = err.localizedDescription
            showingErrorAlert = true
        } catch {
            errorMessage = error.localizedDescription
            showingErrorAlert = true
        }
        isLoading = false
    }
    
    func addToHistory(_ q: String) {
        let trimmed = q.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        history.removeAll { $0.caseInsensitiveCompare(trimmed) == .orderedSame }
        history.insert(trimmed, at: 0)
        if history.count > 10 { history.removeLast() }
        HistoryStore.save(history)
    }
    
    func clearHistory() {
        history.removeAll()
        HistoryStore.clear()
    }
    
    func searchFromHistory(_ item: String) async {
        query = item
        await search()
    }
}
