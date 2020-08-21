//
//  WeatherData.swift
//  Clima
//
//  Created by Vishweshwaran on 19/08/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData : Codable {
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Weather : Codable{
    let main : String
    let id : Int
}


struct Main : Codable {
    let temp : Double
}
