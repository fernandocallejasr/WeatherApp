//
//  WeatherHandler.swift
//  WeatherApp
//
//  Created by user177767 on 9/2/20.
//  Copyright © 2020 Fernando Callejas. All rights reserved.
//

import UIKit

protocol WeatherHandlerDelegateProtocol {
    func didFetchWeather(model: WeatherModel)
}

struct WeatherHandler {
    
    var delegate: WeatherHandlerDelegateProtocol?
    
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=7b4f988423ba70cf3e917dc0e21a1421&units=metric"
    let baseLocationURL = "api.openweathermap.org/data/2.5/weather?appid={your api key}&lat={lat}&lon={lon}"
    
    func fetchWeather(cityName: String) {
        let url = "\(baseURL)&q=\(cityName)".replacingOccurrences(of: " ", with: "%20")
        requestWeather(urlString: url)
    }
    
    func requestWeather(urlString: String) {
        
        if let url = URL(string: urlString) {
        
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let response = self.parseJSON(with: safeData) {
                        self.delegate?.didFetchWeather(model: response)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(with data: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(ResponseData.self, from: data)
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let model = WeatherModel(cityName: name, temperature: temp)
            return model
            
        } catch {
            print(error)
            return nil
        }
                
    }
    
}
