//
//  ViewController.swift
//  WeatherApp
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController , CLLocationManagerDelegate , cityNamePro{
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "edfcf294836192174fe5c449d6f6f364"
    var tempo = ""
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    let changeCityName = ChangeCityViewController()
    

    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url : String, parameter : [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameter).responseJSON {
            response in
            if response.result.isSuccess{
                print("Ntetworking Successful")
                let jsonData : JSON = JSON(response.result.value!)
                print(jsonData)
                self.weatherData(data: jsonData)
                self.updateUIView()
            }
            else{
                print("Error Getting JSON response : \(response.result.error!)")
            }
        }
    }
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func weatherData(data : JSON) {
        let tempResult = data["main"]["temp"].doubleValue
        weatherDataModel.Temperature = Int(tempResult - 273.15)
        weatherDataModel.CityId = data["weather"]["0"]["id"].intValue
        weatherDataModel.CityName = data["name"].stringValue
        weatherDataModel.WeatherIcon = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.CityId)
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIView() {
        cityLabel.text = weatherDataModel.CityName
        temperatureLabel.text = String(weatherDataModel.Temperature)
        weatherIcon.image = UIImage(named: weatherDataModel.WeatherIcon)
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            let lat = String(location.coordinate.latitude)
            let lon = String(location.coordinate.longitude)
            let params : [String : String] = ["lat" : lat , "lon" : lon, "appid" : APP_ID]
            print(params)
            getWeatherData(url: WEATHER_URL, parameter: params)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Can not fetch location"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    func changeCityName(searchCityName: String) {
        print(searchCityName)
        let params : [String : String] = ["q" : searchCityName, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameter: params)
    }
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"{
            let gotoChangeCityView = segue.destination as! ChangeCityViewController
            gotoChangeCityView.delegateDeclaration = self
            
        }
    }
    
    
    
    
}


