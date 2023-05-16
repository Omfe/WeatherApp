//
//  NetworkManager.swift
//  WeatherApp (iOS)
//
//  Created by Omar Gudino on 5/15/23.
//

import Foundation

class NetworkManager {
    static let appKey = "3dc2e1fb2474a111f9d8704b921297f9"
    static let shared = NetworkManager()
    
    func getWeatherFromCityNameOrCoordinates(name: String?, stateCode: String?, latitude: String?, longitude: String?, completed: @escaping(Result<CityWeather?, ErrorEnum>) -> Void) {
        var baseURL = ""
        if let name = name, let stateCode = stateCode {
            let escapedName = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            baseURL = "https://api.openweathermap.org/data/2.5/weather?q=\(escapedName ?? name),\(stateCode),US&appid=\(NetworkManager.appKey)"
        } else if let latitude = latitude, let longitude = longitude {
            baseURL = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(NetworkManager.appKey)"
        }
        
        guard let url = URL(string: baseURL) else {
            completed(.failure(.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(CityWeather.self, from: data)
                completed(.success(decodedResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
