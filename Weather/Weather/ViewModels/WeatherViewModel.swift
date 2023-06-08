//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Sai Kiran on 06/08/23.
//

import Foundation
import CoreLocation

class WeatherViewModel {
    // We can use didset didget methods to update UI and models
    var weatherModel:WeatherModel?
    var apiHelper:ServicesProtocol = APIHelper.shared
    var weatherArr:[Weather] {
        return weatherModel?.weather ?? [Weather]()
    }
    init() { }
    init(weatherModel:WeatherModel) {
        self.weatherModel = weatherModel
    }
    //using closures to malke the code moduler
    func fetchWeatherFromServer(coordnates:CLLocationCoordinate2D, completion: @escaping() -> Void)
    {
        let params:[String:String] = ["lat":String(coordnates.latitude),"lon":String(coordnates.longitude)]
        apiHelper.fetchWeatherData(endPoint: EndPoint(urlParameters: params)) { [weak self] (model, error) in
            if let modelObject = model {
                self?.weatherModel = modelObject
                CacheStorage.store(modelObject, to: .documents, as: "Weather.json")
                completion()
            }
            DispatchQueue.main.async {
                hideIndicator()
            }
        }
    }
    func getLatLongs(cityOrState:String, country:String = "United States",completion: @escaping(_ coordinate: CLLocationCoordinate2D?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(cityOrState) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                completion(nil)
                return
            }
            completion(location.coordinate)
        }
    }
}
