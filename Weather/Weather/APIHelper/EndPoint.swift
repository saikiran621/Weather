//
//  EndPoint.swift
//  Weather
//
//  Created by Sai Kiran on 06/08/23.
//

import Foundation
enum HTTPMethod:String {
    case get = "GET"
    case post = "POST"
}
class EndPoint {
    var path:String = ""
    var urlParameters:[String:Any]
    var method: HTTPMethod = HTTPMethod.get
    let API_KEY = "a47dbf4a9be0f1e4d5fefb56f6f1b231"
    init(path:String? = "", urlParameters:[String:Any]? = [:], method:HTTPMethod? = .get) {
        self.path = path!
        self.urlParameters = urlParameters!
        self.urlParameters["appid"] = API_KEY
        self.method = method!
    }
    
}
