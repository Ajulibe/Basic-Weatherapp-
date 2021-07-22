//
//  WeatherData.swift
//  Clima
//
//  Created by Akachukwu Ajulibe on 20/07/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

//--> Codeable structs must have keys that are the same with the response object keys
//--> from the API

//--> NOTE: all values must be typed. that is why we have Main and Weather extra structs
//--> here the structs are functioning as interfaces in typescript.
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}


struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}


