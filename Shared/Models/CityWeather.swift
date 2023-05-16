//
//  CityWeather.swift
//  WeatherApp (iOS)
//
//  Created by Omar Gudino on 5/15/23.
//

import Foundation

struct CityWeather: Decodable {
    let coord: Location
    let main: Temperature
    let name: String
    let weather: [Weather]
}

struct Temperature: Decodable {
    let temp: Float
}

struct Weather: Decodable {
    let description: String
    let icon: String
    let id: Int
    let main: String
}
