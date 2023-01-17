//
//  WeatherManager.swift
//  Clima
//
//  Created by MAHFUJ on 14/12/2022.
//  Copyright © 2022 MAHFUJ All rights reserved.

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {       // TO have delegate
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: MyWeatherModel)
    func didFailedWithError(_ error: Error)
}

struct WeatherManager {
    let url = "https://api.openweathermap.org/data/2.5/weather?APPID=e161bd44ee4b712b2ad452c2425cb81c&units=metric"
    //var id : Int? = nil
    
    var delegate: WeatherManagerDelegate?
    
     func fetchURL(cityname: String) {
        let weatherUrl = "\(url)&q=\(cityname)"
        print("url: \(weatherUrl)")
        performRequest(url: weatherUrl)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let weatherURL = "\(url)&lat=\(latitude)&lon=\(longitude)"
        print("url: \(weatherURL)")
        performRequest(url: weatherURL)
    }
    
     func performRequest(url : String) {
        //1. create URL
        if let url = URL(string: url) {
            
            //2. create URLSession
            let session = URLSession(configuration: .default)
            
            //3.assign task to session
            let task = session.dataTask(with: url) { [self] (data, response, error) in // completionHandler closure
                if error != nil {
                    delegate?.didFailedWithError(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather) // calling delegate function // self -> WeatherManager object
                    }
                }
            }
            
            //4. start task
            task.resume()
        }
    }
    
    
     func parseJSON(weatherData: Data) -> MyWeatherModel? { // this function helps to get temp,id etc. from the JSON Data
        let decoder = JSONDecoder()
        do{
            let decodedWeatherData = try decoder.decode(WeatherData.self, from: weatherData)
            let city = decodedWeatherData.name
            let temp = decodedWeatherData.main.temp
            let id = decodedWeatherData.weather[0].id
            let weatherModel = MyWeatherModel(conditionID: id, cityName: city, temperature: temp)
            //print(weatherModel.temperatureString)
            print("WeatherCondition: \(weatherModel.weatherCondition)")
            return weatherModel
        }
        catch {
            delegate?.didFailedWithError(error)
            return nil
        }
    }
}
