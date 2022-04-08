//
//  APIClient.swift
//  WeatherApp
//
//  Created by Michel Franklin Silva Bernardo on 08/04/22.
//

import Foundation

class APIClient {
    
    static let shared: APIClient = APIClient()
    
    private let apiKey = "b438a75c1f77b8019dcc2b5277f81e85"
    
    let baseURL: String = "https://api.openweathermap.org/data/2.5/weather"
    
    func getWeatherDataURL(lat: String, lon: String) -> String {
        
        return "\(baseURL)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
    }
    
    
    
}
