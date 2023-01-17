//
//  WeatherModel.swift
//  Clima
//
//  Created by MAHFUJ on 16/12/2022.
//  Copyright © 2022 MAHFUJ All rights reserved.
//

import Foundation

struct MyWeatherModel {
    let conditionID : Int
    let cityName : String
    let temperature : Double
    
    
    var temperatureString : String { // computed property
        return String(format: "%0.1f", temperature)
    }
    
    
    var weatherCondition: String {  // computed property; we can directy call it as a property like,                                                                            ob1.weatherCondition
           switch conditionID {
           case 200...299:
               return "cloud.bolt"
           case 300...399:
               return "cloud.drizzle"
           case 500...599:
               return "cloud.rain"
           case 600...699:
               return "cloud.snow"
           case 700...799:
               return "cloud.fog"
           case 800:
               return "sun.max"
           case 801...899:
               return "cloud.bolt.rain"
           default:
               return "cloud"
           }
    }
    
    
}
