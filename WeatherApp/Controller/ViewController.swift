//
//  ViewController.swift
//  WeatherApp
//
//  Created by user177767 on 9/1/20.
//  Copyright © 2020 Fernando Callejas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherHandler = WeatherHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        weatherHandler.delegate = self
    }

    @IBAction func currentLocationPressed(_ sender: UIButton) {
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
        }
    }

}

