//
//  Connection.swift
//  OpenWeatherIOS
//
//  Created by JC on 26/5/22.
//

import Foundation

class Connection {
    
    /**
     Gets the weather from the API.
     
     - Parameter url: URL from which we get the data
     - Parameter completion: Called when the request has finished
     
     - Returns: TownWeather object with all the data
     */
    static func getTownWeather(from url: String, completion: @escaping (_ success: Bool, _ townWeather: TownWeather?, _ error: Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {
            data, response, error in
            
            guard let data = data, error == nil else {
                completion(false, nil, error)
                return
            }
            
            var townWeather: TownWeather?
            do {
                townWeather = try JSONDecoder().decode(TownWeather.self, from: data)
            } catch {
                completion(false, nil, error)
                return
            }
            
            completion(true, townWeather, nil)
        })
        
        // This is what fires the request
        task.resume()
    }
    
}
