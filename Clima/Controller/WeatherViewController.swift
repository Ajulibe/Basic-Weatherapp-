//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController,UITextFieldDelegate,WeatherManagerDelegate {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var weatherManager  = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchTextField.delegate = self //--> to control the keyboard search
        weatherManager.delegate = self //--> essentially saying the delegate property of this weather Manager class is this class
    }
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) // blur when the search is pressed
        
    }
    
    //hwat happens when the go button is pressed
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
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
    }
}

