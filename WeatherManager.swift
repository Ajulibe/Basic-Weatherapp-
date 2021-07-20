//
//  WeatherManager.swift
//  Clima
//
//  Created by Akachukwu Ajulibe on 20/07/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
  
   
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=5584e10cc0181db867d4b1c800250086&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    //--> this take the url string to be queried
    func performRequest(with urlString: String) {
        //--> the following are he steps involved in transfroming the string to a
        //proper url
        
        // --> 1) Create a URL
        if let url = URL(string: urlString) {
            
            // --> 2) Create a URL Session
            let session = URLSession(configuration: .default)
            
            // --> 3) Give the Session a Task
            // --> below, closure is used as a callback function.
            //--> i.e ({$0, $1}) look up closure if confused
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
//                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        //--> here we are trying to call a function in another class and pass
                        //--> a variable to it. BUT we dont want to hardcode the class by instantiating it here
                        //--> we want to use the delegate pattern. So we follow the steps below
                        //--> 1) define a protocol that all classes serving as the delegate must follow
                        //--> 2) Add that protocol to the delegate class and implement the function.
                        //--> 3) create a delegate variable in the calling class and give it a type of the delegate protocol
                        //--> 4) Initialize the delegating class in the calls to serve as a delegate and then assign the delegate property
                        //--> to the class e.g let weaathermanager = WeatherManager() || weathermanager.delegate = self.
                        //--> 5) essentially that class becomes the delegate
                        //--> essentially saying the delegate property of this weather Manager class is this class
                        
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //--> Start the Task
            task.resume()
        }
    }
    
    //--> converting the data to a JSON format to be readable
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
    //--> this is the swift standard way of converting an API response to JSON
        //--> 1) call the JSONDecoder class, You can option + click JSONDecoder() to see an example
        let decoder = JSONDecoder()
        //--> 2) Tell the class to decode the weatherData argument using the WeatherData struct
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            //--> decodedData here is the final JSON decoded response that is conforming
            //--> to the WeatherData interface
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
