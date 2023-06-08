//
//  APIHelperMock.swift
//  Weather
//
//  Created by Sai Kiran on 06/08/23.
//

import Foundation


class APIHelperMock: ServicesProtocol {
    
    public static var shared = APIHelperMock()
    
    private init () {}
    
    func fetchWeatherData(endPoint: EndPoint, onCompletion: @escaping(_ model: WeatherModel? , _ error:Error?) -> Void) {
        let jsonData = readJSON("WeatherData")
        do {
            let codableModel = try JSONDecoder().decode(WeatherModel.self, from: jsonData)
            onCompletion(codableModel,nil)
        } catch let error {
            onCompletion(nil,error)
        }
    }
    
}
