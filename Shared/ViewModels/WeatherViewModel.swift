//
//  WeatherViewModel.swift
//  WeatherApp (iOS)
//
//  Created by Omar Gudino on 5/15/23.
//

import Foundation
import CoreLocation

final class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var alertItem: AlertItem?
    @Published var cityWeather: CityWeather?
    @Published var isLoading = false
    let manager = CLLocationManager()
    static let userLocationKey = "userLocation"
    
    override init() {
            super.init()
            manager.delegate = self
    }
    
    func getWeatherWith(name: String?, stateCode: String?, latitude: String?, longitude: String?) {
        isLoading = true
        
        NetworkManager.shared.getWeatherFromCityNameOrCoordinates(name: name, stateCode: stateCode, latitude: latitude, longitude: longitude) { [self] result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let cityWeather):
                    if let cityWeather = cityWeather {
                        self.cityWeather = cityWeather
                        let userLocation = Location(latitude: cityWeather.coord.lat, longitude: cityWeather.coord.lon)
                        if let encoded = try? JSONEncoder().encode(userLocation) {
                            UserDefaults.standard.set(encoded, forKey: WeatherViewModel.userLocationKey)
                        }
                    } else {
                        self.cityWeather = nil
                    }
                    
                case .failure(let error):
                    switch error {
                    case .invalidData:
                        alertItem = AlertContext.invalidData
                        
                    case .invalidURL:
                        alertItem = AlertContext.invalidURL
                        
                    case .invalidResponse:
                        alertItem = AlertContext.invalidResponse
                        
                    case .unableToComplete:
                        alertItem = AlertContext.unableToComplete
                    }
                }
            }
        }
    }
    
    func searchButtonWasTapped(cityName: String, stateCode: String) {
        getWeatherWith(name: cityName, stateCode: stateCode, latitude: nil, longitude: nil)
    }
    
    func askForLocationPermission() {
        isLoading = true
        if let data = UserDefaults.standard.object(forKey: WeatherViewModel.userLocationKey) as? Data,
           let userLocation = try? JSONDecoder().decode(Location.self, from: data) {
            manager.delegate = nil
            let latitude = "\(userLocation.lat)"
            let longitude = "\(userLocation.lon)"
            getWeatherWith(name: nil, stateCode: nil, latitude: latitude, longitude: longitude)
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    manager.requestLocation()
                    break
            
                case .denied, .restricted:
                    self.cityWeather = nil
                    isLoading = false
                    
                case .notDetermined:
                    manager.requestWhenInUseAuthorization()
                    break
                    
                default:
                    break
                }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let userLocation = Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            if let encoded = try? JSONEncoder().encode(userLocation) {
                UserDefaults.standard.set(encoded, forKey: WeatherViewModel.userLocationKey)
                manager.delegate = nil
            }
            
            let latitude = "\(userLocation.lat)"
            let longitude = "\(userLocation.lon)"
            getWeatherWith(name: nil, stateCode: nil, latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.cityWeather = nil
        isLoading = false
    }
}
