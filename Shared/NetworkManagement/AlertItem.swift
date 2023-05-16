//
//  AlertItem.swift
//  WeatherApp (iOS)
//
//  Created by Omar Gudino on 5/15/23.
//

import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var dismissButton: Alert.Button?
    var message: Text
    var title: Text
}

enum AlertContext {
    static let invalidURL = AlertItem(dismissButton: .default(Text("Ok")),
                                      message: Text("There is an error trying to reach the server. Double check correct city name with state"),
                                      title: Text("Invalid City Name"))
    
    static let unableToComplete = AlertItem(dismissButton: .default(Text("Ok")),
                                            message: Text("Unable to complete your request at this time. Please check your internet connection."),
                                            title: Text("Server Error"))
    
    static let invalidResponse = AlertItem(dismissButton: .default(Text("Ok")),
                                           message: Text("Invalid response from the server. Please try a valid city name."),
                                           title: Text("Server Error"))
    
    static let invalidData = AlertItem(dismissButton: .default(Text("Ok")),
                                       message: Text("The data received from the server was invalid. Please try again or contact support."),
                                       title: Text("Server Error"))
}

