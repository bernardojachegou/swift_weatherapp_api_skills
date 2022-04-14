//
//  ViewController.swift
//  WeatherApp
//
//  Created by Michel Franklin Silva Bernardo on 08/04/22.
//

import UIKit

import Alamofire

import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureValueLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    @IBOutlet weak var windSpeedValueLabel: UILabel!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }
    
    func getWeatherWithURLSession(lat: String, long: String) {
        
        guard let weatherURL = URL(string: APIClient.shared.getWeatherDataURL(lat: lat, lon: long)) else {return}
        
        URLSession.shared.dataTask(with: weatherURL) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {return}
            
            do {
                guard let weatherData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("there was an error converting data into JSON")
                    return
                }
                
                print(weatherData)
                
            } catch {
                print("error converting data into JSON")
            }
            
        }.resume()
    }
    
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            print("latitude: \(latitude) and longitude: \(longitude)")
            
            getWeatherWithURLSession(lat: latitude, long: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
            
        case .denied,  .restricted:
            let alertController = UIAlertController(title: "Location Access Disabled", message: "Weather App needs your location to give a weather forecast. Open your settings to change authorization.", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                alertController.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open", style: .default) { (action) in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
            alertController.addAction(openAction)
            
            present(alertController, animated: true, completion: nil)
            
            break
        @unknown default:
            fatalError()
        }
    }
}

