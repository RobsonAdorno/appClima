//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    
    
    //TODO: Declare instance variables here
    let managerLocation = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        managerLocation.delegate = self
        managerLocation.desiredAccuracy = kCLLocationAccuracyHundredMeters
        managerLocation.requestWhenInUseAuthorization()
        managerLocation.startUpdatingLocation()
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url: String, parameters: [String:String]){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in
            
            if response.result.isSuccess {
                
                print("Sucess! Got the weather data")
                
                let jsonWeather = JSON(response.result.value!)
                
                self.updateWeatherData(json:jsonWeather)
            }else{
                
                print("Error \(response.result.error!)")
                self.cityLabel.text = "Connection issues!"
            }
        }
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json: JSON){
        
        if let tempResult = json["main"]["temp"].double{
            
            weatherDataModel.temperature = Int(tempResult - 273.15)
            
            weatherDataModel.city = json["name"].stringValue
            
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
            
        }else{
            cityLabel.text = "This is not happen"
        }
    }
        
        
        
        //MARK: - UI Updates
        /***************************************************************/
        
        
        //Write the updateUIWithWeatherData method here:
        
        func updateUIWithWeatherData(){
            
            cityLabel.text = weatherDataModel.city
            temperatureLabel.text = String(weatherDataModel.temperature)
            weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
            
        }
        
        
        
        
        //MARK: - Location Manager Delegate Methods
        /***************************************************************/
        
        
        //Write the didUpdateLocations method here:
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locations[locations.count - 1]
            
            if location.horizontalAccuracy > 0 {
                
                managerLocation.stopUpdatingLocation()
                
                print("Coordinate: \(location.coordinate.latitude) and \(location.coordinate.longitude)")
                
                let latitude = String(location.coordinate.latitude)
                let longtitude = String(location.coordinate.longitude)
                
                let params:[String:String] = ["lati": latitude , "long": longtitude, "APPID": APP_ID]
                getWeatherData(url: WEATHER_URL, parameters: params)
            }
        }
        
        
        //Write the didFailWithError method here:
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
            cityLabel.text = "Location Unavaible"
        }
        
        
        
        
        //MARK: - Change City Delegate methods
        /***************************************************************/
        
        
        //Write the userEnteredANewCityName Delegate method here:
        
        
        
        //Write the PrepareForSegue Method here
        
        
        
        
        
    }
}


