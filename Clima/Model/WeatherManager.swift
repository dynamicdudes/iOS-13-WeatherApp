//
//  WeatherManager.swift
//  Clima
//
//  Created by Vishweshwaran on 19/08/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation


protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager , weather: WeatherModel)
    func didFailedToLoadError(error : Error)
}


struct WeatherManager {
    
    let mainURL : String = "https://api.openweathermap.org/data/2.5/weather?&appid=77d901b1230d8d2578659c190aa1f011&units=imperial"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName : String)  {
        let weatherUrl = "\(mainURL)&q=\(cityName)"
        performRequest(with : weatherUrl)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let weatherUrl = "\(mainURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: weatherUrl)
    }
    
    // TODO: Networking
    func performRequest(with urlString : String){
        
        // 1. Create URL
        if let url = URL(string: urlString){
            
            // 2. Create a Session
            let session = URLSession(configuration: .default)
            
            // 3. Give the Session a Task to work
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailedToLoadError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJson(safeData){
                        self.delegate?.didUpdateWeather(self,weather: weather)
                    }
                }
                
            }
            
            // 4. Start the Task
            task.resume()
        }
    }
    
    func parseJson(_ weatherData : Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let cityName = decodedData.name
            let temperature = decodedData.main.temp
            
            let currentWeather = WeatherModel(conditionId: id, cityName: cityName, temperature: temperature)
            
            return currentWeather
        
        }
        catch{
            delegate?.didFailedToLoadError(error: error)
            return nil
        }
    }
    
    
    
}
