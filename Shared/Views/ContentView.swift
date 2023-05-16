//
//  ContentView.swift
//  Shared
//
//  Created by Omar Gudino on 5/14/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var cityName: String = ""
    @State private var stateCode: String = "AK"
    
    let states = [ "AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","PR","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"]
    
    var body: some View {
        ZStack {
            BackgroundView(topColor: .blue, bottomColor: .gray)
            VStack {
                CityTextView(cityName: viewModel.cityWeather?.name ?? "--")
                
                VStack {
                    CityWeatherImageIcon(weather: viewModel.cityWeather?.weather.first ?? nil)
                    CityWeatherTemperatureText(temperatureNumber: Int(viewModel.cityWeather?.main.temp ?? 00))
                }
                HStack {
                    //I didnt see much of a need for a seperate screen for searching, but my UI was not the best, so maybe it was better to just jump to a different screen with more Apple friendly UI
                    TextField("City Name & State Code", text: $cityName)
                        .padding(8)
                        .font(.headline)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(6)
                        .border(.white)
                        .padding(.horizontal, 10)
                    //Ideally the picker has better UI OR it navigates to a different screen
                    Picker("State Code", selection: $stateCode) {
                        ForEach(states, id: \.self) {
                            Text($0)
                        }
                    }
                    .background(.white)
                    .padding(.horizontal, 10)
                    Button(action: {
                        if !cityName.isEmpty {
                            viewModel.searchButtonWasTapped(cityName: cityName, stateCode: stateCode)
                        }
                        //Handle sending user a error message about a emtpy city name
                    }, label: {
                        Text("Search")
                            .background(.white)
                    })
                    .padding(.horizontal, 10)
                    if viewModel.isLoading { LoadingView() }
                }
                Spacer()
            }
            .onAppear { viewModel.askForLocationPermission() }
            
            if viewModel.isLoading { LoadingView() }
        }
        
        .alert(item: $viewModel.alertItem) { AlertItem in
            Alert(title: AlertItem.title, message: AlertItem.message, dismissButton: AlertItem.dismissButton)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
