//
//  ViewController.swift
//  WeatherApp
//
//  Created by user177767 on 9/1/20.
//  Copyright © 2020 Fernando Callejas. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityViewCollection: UICollectionView!
    
    var weatherHandler = WeatherHandler()
    var locationManager = CLLocationManager()
    
    var citiesArray = [City]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        
        weatherHandler.delegate = self
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        cityViewCollection.collectionViewLayout = layout
        
        cityViewCollection.register(CityCollectionViewCell.nib(), forCellWithReuseIdentifier: CityCollectionViewCell.identifier)
        
        cityViewCollection.delegate = self
        cityViewCollection.dataSource = self
        
        cityViewCollection.showsHorizontalScrollIndicator = false
        
        loadCities()
        
        if citiesArray.count != 0 {
            weatherHandler.fetchWeather(cityName: citiesArray[0].cityName!)
        }
        
    }

    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
}

//MARK: - Persistent Data Methods

extension ViewController {
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving Core Data context: \(error)")
        }
    }
    
    func loadCities() {
        
        let request: NSFetchRequest<City> = City.fetchRequest()
        
        do {
            citiesArray = try context.fetch(request)
        } catch {
            print("Error Loading Cities: \(error)")
        }
        
        cityViewCollection.reloadData()
        
    }
    
    func addCity(withName cityText: String) {
        
        var cityString = [String]()
        
        if citiesArray.count != 0 {
            for city in citiesArray {
                cityString.append(city.cityName!)
            }
            
            if cityString.contains(cityText) {
                return
            }
            
            let newCity = City(context: context)
            newCity.cityName = cityText
            
            citiesArray.append(newCity)
            
            saveContext()
            
            cityViewCollection.reloadData()
        } else {
            let newCity = City(context: context)
            newCity.cityName = cityText
            
            citiesArray.append(newCity)
            
            saveContext()
            
            cityViewCollection.reloadData()
        }
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
            
            let cityName = model.cityName
            let temperature = model.temperature
            
            if cityName == "" {
                print("Unnamed City")
            } else {
                
                self.cityLabel.text = cityName
                self.temperatureLabel.text = "\(Int(temperature)) °C"
                
                if let conditionImage = UIImage(systemName: model.conditionString) {
                    self.weatherConditionImage.image = conditionImage
                }
                
                self.addCity(withName: cityName)
            
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

//MARK: - Collection View Delegate Protocol

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if citiesArray.count != 0 {
            weatherHandler.fetchWeather(cityName: citiesArray[indexPath.row].cityName!)
        }
        
    }
    
}

//MARK: - Collection View Data Source Protocol

extension  ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let citiesNumber = citiesArray.count != 0 ? citiesArray.count : 1
        
        return citiesNumber
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionViewCell.identifier, for: indexPath) as! CityCollectionViewCell
        
        let title = citiesArray.count != 0 ? citiesArray[indexPath.row].cityName : "Add place"
        
        cell.setTitle(with: title!)
        
        return cell
        
    }
    
}
    
//MARK: - Collection View Delegate Flow Layout Protocol
    
    extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
}
