//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var reloadButton: UIButton!
    
    var weatherManager  = WeatherManager()
    //--> this is for the location
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //--> obtaining location data
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        
        // Do any additional setup after loading the view.
        searchTextField.delegate = self //--> to control the keyboard search
        weatherManager.delegate = self //--> essentially saying the delegate property of this weather Manager class is this class
    }
    
    
    @IBAction func reloadButtonPressed(_ sender: UIButton) {
        // viewDidLoad() //--> not the best perfomance practice
        locationManager.requestLocation() //--> this method requests fror the location
        
    }
    
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //--> this is to get last gotten gps location in the array for increased accuracy
        if let location = locations.last {
            //--> when we get our last location we should stop updating the location
            locationManager.stopUpdatingLocation()
            let lon = location.coordinate.longitude
            let lat = location.coordinate.latitude
            
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    
    
}



// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) // blur when the search is pressed
    }
    
    //what happens when the go button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        return true
    }
    
    //to check if you are going to allow the user to end editing/blur
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else {
            textField.placeholder = "Type something"
            return false
        }
        
    }
    // reset the text field content to an empty string
    //when the keyboard is pressed
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
}



// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        //--> when using information that is obtained from an API response, wrap it in
        //--> the dispatch queue closure to avoid blocking the UI
        
        DispatchQueue.main.async {
            //--> settin the temperature
            self.temperatureLabel.text = weather.temperatureString
            //--> assign a image to the image view
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            //--> setting the city name
            self.cityLabel.text = weather.cityName
        }
    }
    
    
    func didFailWithError(error: Error) {
        let alert =  UIAlertController(title: "Error", message: "an error has occured", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
