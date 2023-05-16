//
//  CityWeatherCustomViews.swift
//  WeatherApp (iOS)
//
//  Created by Omar Gudino on 5/15/23.
//

import SwiftUI

struct BackgroundView: View {
    var topColor: Color
    var bottomColor: Color
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [topColor, bottomColor]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CityTextView: View {
    var cityName: String
    
    var body: some View {
        Text(cityName)
            .font(.system(size: 40, weight: .medium))
            .foregroundColor(.white)
            .padding()
    }
}

struct CityWeatherImageIcon: View {
    var weather: Weather?
    
    var body: some View {
        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather?.icon ?? "")@4x.png")){ phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable()
                     .frame(maxWidth: 100, maxHeight: 100)
                     .scaledToFit()
                     .cornerRadius(5)
            case .failure:
                Image(systemName: "cloud.sun.fill")
            @unknown default:
                EmptyView()
            }
        }
    }
}

struct CityWeatherTemperatureText: View {
    var temperatureNumber: Int
    
    var body: some View {
        let celsiusTemp = temperatureNumber - 273
        Text(String(celsiusTemp) + "°")
            .font(.system(size: 70, weight: .medium))
            .foregroundColor(.white)
    }
}
