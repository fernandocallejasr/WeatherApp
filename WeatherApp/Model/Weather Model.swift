//
//  Weather Model.swift
//  WeatherApp
//
//  Created by user177767 on 9/2/20.
//  Copyright © 2020 Fernando Callejas. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let cityName: String
    let temperature: Double
    let id: Int
    
    var conditionString: String {
        
        switch id {
            
        case 200...202:
            return "cloud.bolt.rain"
        case 210...221:
            return "cloud.bolt"
        case 230...232:
            return "cloud.bolt.rain"
            
        case 300...321:
            return "cloud.drizzle"
            
        case 500...531:
            return "cloud.heavyrain"
            
        case 600...622:
            return "cloud.snow"
            
        case 781:
            return "tornado"
            
        case 800:
            return "sun.max"
            
        case 801...804:
            return "cloud.fill"
        
        default:
            return "thermometer"
        }
        
    }
    
}
