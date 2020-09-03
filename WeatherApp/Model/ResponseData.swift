//
//  ResponseData.swift
//  WeatherApp
//
//  Created by user177767 on 9/2/20.
//  Copyright © 2020 Fernando Callejas. All rights reserved.
//

import Foundation

struct ResponseData: Codable {
    
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}


// path city name: name
// path temp: main.temp
// path id: weather[0].id
