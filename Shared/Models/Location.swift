//
//  Location.swift
//  WeatherApp (iOS)
//
//  Created by Omar Gudino on 5/15/23.
//

import Foundation

struct Location: Codable {
    let lat: Double
    let lon: Double
    
    init(latitude: Double, longitude: Double) {
        self.lat = latitude
        self.lon = longitude
    }
}
