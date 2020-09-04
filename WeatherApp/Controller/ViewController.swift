//
//  ViewController.swift
//  WeatherApp
//
//  Created by user177767 on 9/1/20.
//  Copyright © 2020 Fernando Callejas. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherHandler = WeatherHandler()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        
        weatherHandler.delegate = self
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
        weatherHandler.fetchWeather(cityName: "London")
    }

    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    
}

//MARK: - Text Field Delegate Methods

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if textField.text != "" {
                weatherHandler.fetchWeather(cityName: text)
            }
        }
        
        textField.text = ""
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
}

//MARK: - Weather Handler Protocol

extension ViewController: WeatherHandlerDelegateProtocol {
    
    func didFetchWeather(model: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = model.cityName
            self.temperatureLabel.text = "\(model.temperature) °C"
            
            if let conditionImage = UIImage(systemName: model.conditionString) {
                self.weatherConditionImage.image = conditionImage
            }
            
        }
    }

}

//MARK: - CLLocation Manager Delegate Protocol

extension ViewController: CLLocationManagerDelegate {
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = "\(location.coordinate.latitude)"
            let longitude = "\(location.coordinate.longitude)"
            
            weatherHandler.fetchWeather(lon: longitude, lat: latitude)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error obtaining current location: \(error)")
    }
    
}

