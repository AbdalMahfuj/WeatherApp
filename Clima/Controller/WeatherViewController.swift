//
//  ViewController.swift
//  Clima
//
//  Created by MAHFUJ on 16/12/2022.
//  Copyright © 2022 MAHFUJ All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
            override func viewDidLoad() {
                super.viewDidLoad()
                // Do any additional setup after loading the view.
                
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                
                locationManager.requestLocation()
                
                weatherManager.delegate = self // set this class as delegate
                searchTextField.delegate = self // set this class as delegate
        }
    
    @IBAction func BtnLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK: - UITextFieldDelegate
extension WeatherViewController : UITextFieldDelegate {
    @IBAction func SearchBtn(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ searchTextField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    
    func textFieldShouldEndEditing(_ searchTextField: UITextField) -> Bool {
        if(searchTextField.text != "") {
            return true
        }
        else {
            searchTextField.placeholder = "Search Area.."
        }
        return false
    }
    
    
    func textFieldDidEndEditing(_ searchTextField: UITextField) {
        // searchfield.text to get weather data
        if let city = searchTextField.text  {
            weatherManager.fetchURL(cityname: city)
        }
            searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: MyWeatherModel) {
        print(weather.temperatureString)
        // UPDATE UI after all calculations have been done(in the background)
        DispatchQueue.main.async {  // for closure 'self' is mentioned
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.weatherCondition)
            print(weather.conditionID)
        }
    }
    
    
    func didFailedWithError(_ error: Error) {
        print("Error: \(error)")
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("got location")
        if let location = locations.last {
            locationManager.stopUpdatingLocation() // if already has the location, dont need to update it again
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("got error: \(error)" )
    }
}

