//
//  WeatherData.swift
//  Clima
//
//  Created by MAHFUJ on 16/12/2022.
//  Copyright © 2022 MAHFUJ All rights reserved.
//

import Foundation

struct WeatherData: Codable { // "weather": [ { "id": 701, "main": "Mist", "description": "mist", "icon": "50d" } ]
    let name: String
    let main: Main
    let weather: [WeatherDes]
}

struct Main : Codable { // typealias Codable = Decodable & Encodable:  For JSON decode and encode
    let temp : Double
}

struct WeatherDes: Codable {
    let id: Int
    let description : String
}
