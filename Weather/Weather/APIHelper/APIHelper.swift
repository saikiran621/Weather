//
//  APIHelper.swift
//  Weather
//
//  Created by Sai Kiran on 06/08/23.
//

import Foundation




typealias completionHandler = (Bool,Any?) -> Void


protocol ServicesProtocol {
    func fetchWeatherData(endPoint: EndPoint, onCompletion: @escaping(_ model: WeatherModel? , _ error:Error?) -> Void)
}
// APIHelper - Network layer to seperate the API cals
// future we wanted to decouple we can do that if we have seperate layer
// We can use combine framework as well for making API calls

class APIHelper: ServicesProtocol {
    public static var shared = APIHelper()
    var WEATHER_BASE_URL = "https://api.openweathermap.org/data/2.5/weather"
    private init () { }
    
    func fetchWeatherData(endPoint: EndPoint, onCompletion: @escaping(_ model: WeatherModel? , _ error:Error?) -> Void) {
        self.get(endPoint: endPoint) { (isSuccess, jsonData) in
            if let error = jsonData as? Error {
                onCompletion(nil,error)
                return
            }
            if let dataObj = jsonData as? Data{
                if let JSONString = String(data: jsonData as! Data, encoding: String.Encoding.utf8) {
                    print("Result JSON ==========================>\n \(JSONString) \n================================================")
                }
                do {
                    let codableModel = try JSONDecoder().decode(WeatherModel.self, from: dataObj)
                    onCompletion(codableModel,nil)
                } catch let error {
                    print(error)
                    print(error.localizedDescription)
                    onCompletion(nil,error)
                }
            }
        }
    }
    
    func get(endPoint:EndPoint, compleationHandler:@escaping completionHandler ) {
        
        var url = URL(string: WEATHER_BASE_URL + (endPoint.path.count > 0 ? endPoint.path : ""))!
        if endPoint.urlParameters.count > 0 {
            let queryItems = endPoint.urlParameters.map {
                return URLQueryItem(name: "\($0)", value: "\($1)")
            }
            var urlComponents = URLComponents(url: url , resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = queryItems
            url = urlComponents?.url ?? url
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        print("GET request:\(request)");
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.validateResponse(data: data, response: response, error: error) { (isSuccess, jsonData) in
                compleationHandler(isSuccess,jsonData)
            }
        }.resume()
    }
    private func validateResponse(data:Data?, response:URLResponse?, error:Error?, compleationHandler:@escaping completionHandler ) {

        if !(response?.isSuccessStausCode ?? false) || error != nil {
            if let err = error {
                compleationHandler(false,err)
                return
            }
        }
        guard let data = data else {
            compleationHandler(false,error)
            return
        }
        compleationHandler(true,data)
    }
    
}
extension URLResponse {
    
    var isSuccessStausCode:Bool {
       if let httpResponse = self as? HTTPURLResponse {
            return (200...299).contains(httpResponse.statusCode)
        }
        return false
    }

}
