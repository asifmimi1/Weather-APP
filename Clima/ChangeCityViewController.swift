//
//  ChangeCityViewController.swift
//  WeatherApp
//
//

import UIKit


//Write the protocol declaration here:
protocol cityNamePro {
    func changeCityName(searchCityName : String)
}


class ChangeCityViewController: UIViewController {
    
    //Declare the delegate variable here:
    var delegateDeclaration : cityNamePro?
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        
        //1 Get the city name the user entered in the text field
            let city = changeCityTextField.text!
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        delegateDeclaration?.changeCityName(searchCityName: city)
        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
