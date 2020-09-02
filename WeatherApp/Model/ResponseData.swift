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
    
}

struct Main: Codable {
    let temp: Double
}


// path city name: name
// path temp: main.temp
