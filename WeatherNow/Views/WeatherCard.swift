//
//  WeatherCard.swift
//  WeatherNow
//
//  Created by Agam Airi on 2025-08-20.
//

import SwiftUI

struct WeatherCard: View {
    let weather: WeatherResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(weather.name)
                        .font(.title2)
                        .bold()
                    Text(weather.weather.first?.description.capitalized ?? "—")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if let icon = weather.weather.first?.icon,
                   let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView().frame(width: 64, height: 64)
                        case .success(let image):
                            image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                        case .failure:
                            Image(systemName: "cloud.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
            HStack(alignment: .firstTextBaseline) {
                Text(String(format: "%.0f° C", weather.main.temp))
                    .font(.system(size: 44, weight: .bold))
                Spacer()
            }
        }
        .padding()
        .background(.ultraThickMaterial)
        .background(Color.blue)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct WeatherCard_Previews: PreviewProvider {
    static var previews: some View {    WeatherCard(weather: WeatherResponse(name: "Toronto", main: .init(temp:
    12.3), weather: [.init(description: "clear sky", icon: "01d")]))
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
