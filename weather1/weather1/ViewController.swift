//
//  ViewController.swift
//  weather1
//
//  Created by Гость on 21.04.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController{
    
    @IBOutlet weak var cityNameLabel: UILabel!
   @IBOutlet weak var weatherDiscriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    var weatherData = WeatherData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       startLocationManager()
    }
    
    func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    
    func updateView() {
        cityNameLabel.text = weatherData.name
        weatherDiscriptionLabel.text = DataSource.weatherIDs[weatherData.weather[0].id]
       temperatureLabel.text = weatherData.main.temp.description + "*"
        weatherIconImageView.image = UIImage(named: weatherData.weather[0].icon)
    }
    
   func updateWeatherInfo(latitude: Double, longtitude: Double) {
        let session = URLSession.shared
        let url = URL (string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longtitude.description)&units=metric&lang=ru&appid=837f2fc955f67f6b7c245ec5ed3b7fb8")!
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("DataTask error: \(error!.localizedDescription)")
            return
        }
            do {
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                DispatchQueue.main.async {
                print(self.weatherData)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }


}

extension ViewController: CLLocationManagerDelegate {
    private func locationManger(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            //updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longtitude: lastLocation.coordinate.longitude)
            print(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
        }
    }
}
