//
//  TownUrl.swift
//  OpenWeatherIOS
//
//  Created by JC on 29/5/22.
//

import Foundation

class TownUrl {
    let baseUrl = "http://api.openweathermap.org"
    let paths = [
        "data": "/data/2.5/weather",
        "geo": "/geo/1.0/reverse"
    ]
    let apiKey = "34a31e8efb2b36328928533c63e9dec1"

    /**
     Builds the URL that that is going to be sended to the API through the Data layer
     */
    func getUrl(path: String, parameters: [String : String]) -> URL {
        var nameUrlComponents = URLComponents(string: baseUrl)!
        nameUrlComponents.path = path
        nameUrlComponents.queryItems = .init(parameters)
        return nameUrlComponents.url!
    }
}

extension Array where Element == URLQueryItem {
    init<T: LosslessStringConvertible>(_ dictionary: [String: T]) {
        self = dictionary.map({ (key, value) -> Element in
            URLQueryItem(name: key, value: String(value))
        })
    }
}
