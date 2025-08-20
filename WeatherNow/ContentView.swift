//
//  ContentView.swift
//  WeatherNow
//
//  Created by Agam Airi on 2025-08-20.
//

import SwiftUI

struct ContentView: View {
//    @State private var cityName: String = ""
//    @State private var History  : [String] = []
    @StateObject private var vm = WeatherViewModel()
    var body: some View {
        NavigationStack {
            VStack (spacing: 12) {
                searchBar
                if vm.isLoading {
                    ProgressView().padding(.top, 8)
                }
                
                if let weather = vm.currentWeather {
                    WeatherCard(weather: weather)
                        .padding(.top, 8)
                        .transition(.opacity)
                }
                
                historyList
                Spacer()
                //
            }
            .padding(12)
            .navigationTitle("Weather Now")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { vm.clearHistory() }) {
                        Image(systemName: "trash")
                    }.disabled(vm.history.isEmpty)
                }
            }
            .alert("Error", isPresented: $vm.showingErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(vm.errorMessage ?? "Unknown error")
            }
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 8) {
            TextField("Search city...", text: $vm.query)
            .textFieldStyle(.roundedBorder)
            .submitLabel(.search)
            .onSubmit {
                Task { await vm.search() }
        }
        Button(action: {
            Task { await vm.search() }
        }) {
        Text("Go")
                .frame(minWidth: 44)
        }
        .buttonStyle(.borderedProminent)
        }
    }
    
    private var historyList: some View {
    GroupBox("Search history") {
    if vm.history.isEmpty {
    Text("No recent searches")
    .foregroundColor(.secondary)
    .padding(.vertical, 8)
    } else {
    ScrollView(.horizontal, showsIndicators: false) {
    HStack(spacing: 8) {
    ForEach(vm.history, id: \.self) { item in
    Button(action: {
    Task { await vm.searchFromHistory(item) }
    }) {
    Text(item)
    .padding(.vertical, 8)
    .padding(.horizontal, 12)
    .background(.thinMaterial)
    .cornerRadius(8)
    }
    }
    }
    .padding(.vertical, 6)
    }
    }
    }
    .padding(.top, 12)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View { ContentView() }
}

//#Preview {
//    ContentView()
//}


