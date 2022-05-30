//
//  Connection.swift
//  OpenWeatherIOS
//
//  Created by JC on 26/5/22.
//

import Foundation
import CoreLocation

class TownData {
    
    static let shared = TownData()

    private init() { }
    
    /**
     Gets the weather from the name of a town retrieved by the API.
     
     - Parameter url: URL from which we get the data
     - Parameter completion: Called when the request has finished. Returns an optional TownWeather (if retrieved successfully) or an optional error if the town couldn't be retrieved.
     */
    func getTownWeather(url: URL?, completion: @escaping (_ success: Bool, _ townWeather: TownWeather?, _ error: Error?) -> Void) {
        if let safeUrl = url {
            URLSession.shared.dataTask(with: safeUrl, completionHandler: {
                data, response, error in
                
                guard let data = data, error == nil else {
                    completion(false, nil, error)
                    return
                }
                
                do {
                    let townWeather = try JSONDecoder().decode(TownWeather.self, from: data)
                    completion(true, townWeather, nil)
                    return
                } catch {
                    completion(false, nil, error)
                    return
                }
            }).resume()
        } else {
            completion(false, nil, "Unable to obtain data from the input town" as? Error)
        }
    }
    
    /**
     Gets the name of a town from its coordinates.
     
     - Parameter url: URL from which we get the data
     - Parameter completion: Called when the request has finished. Returns an optional TownWeather (if retrieved successfully) or an optional error if the town couldn't be retrieved.
     */
    func getTownName(url: URL, completion: @escaping (_ success: Bool, _ townName: TownName?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: {
            data, response, error in
            
            guard let data = data, error == nil else {
                completion(false, nil, error)
                return
            }
            
            do {
                let names = try JSONDecoder().decode([TownName].self, from: data)
                if names.count > 0 {
                    completion(true, names[0], nil)
                } else {
                    completion(false, nil, error)
                    return
                }
            } catch {
                completion(false, nil, error)
                return
            }
        }).resume()
    }
    
}
