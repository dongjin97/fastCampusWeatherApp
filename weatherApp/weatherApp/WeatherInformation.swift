//
//  WeatherInformation.swift
//  weatherApp
//
//  Created by 원동진 on 2022/09/27.
//

import Foundation
struct WeatherInformation : Codable {
    let weather: [Weather]
    let main: Temp
    let name : String
}
struct Weather : Codable {
    let id : Int
    let main : String
    let description : String
    let icon : String
}
struct Temp : Codable {
    let temp : Double
    let feels_like : Double
    let temp_min : Double
    let temp_max : Double
}


struct ErrorMessage : Codable {
    let message : String
}
