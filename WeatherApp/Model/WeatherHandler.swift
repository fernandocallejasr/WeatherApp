//
//  WeatherHandler.swift
//  WeatherApp
//
//  Created by user177767 on 9/2/20.
//  Copyright © 2020 Fernando Callejas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol WeatherHandlerDelegateProtocol {
    func didFetchWeather(model: WeatherModel)
}

struct WeatherHandler {
    
    var delegate: WeatherHandlerDelegateProtocol?
    
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=7b4f988423ba70cf3e917dc0e21a1421&units=metric"
    
    func fetchWeather(cityName: String) {
        let url = "\(baseURL)&q=\(cityName)".replacingOccurrences(of: " ", with: "%20")
        requestWeather(urlString: url)
    }
    
    func fetchWeather(lon: String, lat: String) {
        let url = "\(baseURL)&lat=\(lat)&lon=\(lon)"
        requestWeather(urlString: url)
    }
    
    func requestWeather(urlString: String) {
        
        Alamofire.request(urlString).responseJSON { (response) in
            if response.result.isSuccess {
                
                let weatherJSON = JSON(response.result.value!)
                if let weather = self.parseJSON(with: weatherJSON) {
                    self.delegate?.didFetchWeather(model: weather)
                }
            }
        }
    }
    
    func parseJSON(with json: JSON) -> WeatherModel? {
        
        let name = json["name"].stringValue
        let temp = json["main"]["temp"].doubleValue
        let weatherID = json["weather"][0]["id"].intValue
        
        let weather = WeatherModel(cityName: name, temperature: temp, id: weatherID)
        
        return weather
                
    }
    
}
