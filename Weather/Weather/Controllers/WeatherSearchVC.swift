//
//  ViewController.swift
//  Weather
//
//  Created by Sai Kiran on 06/08/23.
//

import UIKit
import CoreLocation

/*
 1.MVVM approach to add the tests, if the time permists i can add Unit tests
 */
class WeatherSearchVC: UIViewController {

    var viewModel:WeatherViewModel?
    // CLLocationManager - logic can be seperated into a different class to reuse
    let locationManager = CLLocationManager()

    var searchView:WeatherSearchView {
        return self.view as! WeatherSearchView
    }
    convenience init(vm: WeatherViewModel) {
        self.init()
        self.viewModel = vm
    }
    override func loadView() {
        super.loadView()
        self.view = WeatherSearchView(viewModel: self.viewModel ?? WeatherViewModel())
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weather Search"
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
//        DispatchQueue.main.async {
//            if CLLocationManager.locationServicesEnabled() {
//                self.locationManager.delegate = self
//                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//                self.locationManager.startUpdatingLocation()
//            }
//        }
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled(){
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest/// kCLLocationAccuracyBest is the default
                self.checkLocationAuthorization()
            }
        }
    }
    private func checkLocationAuthorization(){
            switch locationManager.authorizationStatus{
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                /// app is authorized
                locationManager.startUpdatingLocation()
            default:
                break
            }
        }
    // To handle the View on device orientation change
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.searchView.setNeedsLayout()
            self.searchView.layoutIfNeeded()
        })
    }
}
extension WeatherSearchVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        searchView.fetchWeatherDatafromServer(coord: locValue)
        locationManager.stopUpdatingLocation()
        //Stop locations To Improve battery performance
    }
    
    
}

