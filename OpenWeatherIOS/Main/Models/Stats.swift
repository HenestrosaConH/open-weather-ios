//
//  Stats.swift
//  OpenWeatherIOS
//
//  Created by JC on 28/5/22.
//

class Stats {
    var maxTemp = ["city": "", "value": 0.0] as [String : Any]
    var maxHumidity = ["city": "", "value": 0] as [String : Any]
    var maxWindSpeed = ["city": "", "value": 0.0] as [String : Any]
    var maxRainLastHour = ["city": "", "value": 0.0] as [String : Any]
    
    /**
     Compares the stats of a given town and updates them if the passed TownWeather has a higher value of a certain parameter than the one established before.
     
     - Parameter townWeather: TownWeather to be evaluated.
     
     - Returns: Stats to String
     */
    func updateStats(townWeather: TownWeather) {
        let name = townWeather.name
        
        let temperature = townWeather.main.temp
        if temperature > maxTemp["value"] as! Double {
            maxTemp["city"] = name
            maxTemp["value"] = temperature
        }
        
        let humidity = townWeather.main.humidity
        if humidity > maxHumidity["value"] as! Int {
            maxHumidity["city"] = name
            maxHumidity["value"] = humidity
        }
        
        let windSpeed = townWeather.wind.speed
        if windSpeed > maxWindSpeed["value"] as! Double {
            maxWindSpeed["city"] = name
            maxWindSpeed["value"] = windSpeed
        }
        
        if let safeRain = townWeather.rain?.lastHour {
            if safeRain > maxRainLastHour["value"] as! Double {
                maxRainLastHour["city"] = name
                maxRainLastHour["value"] = safeRain
            }
        }
    }
    
    func toString() -> String {
        let cityRainLastHour = maxRainLastHour["city"] as! String
        
        return """
        Highest temperature: \(maxTemp["city"]!)
        Temperature: \(maxTemp["value"]!)ºC
        
        Highest humidity: \(maxHumidity["city"]!)
        Humidity: \(maxHumidity["value"]!)%
        
        Highest wind speed: \(maxWindSpeed["city"]!)
        Wind speed: \(maxWindSpeed["value"]!) meter/sec
        
        Rainiest town in the last hour: \(cityRainLastHour.isEmpty  ? "-" : cityRainLastHour)
        Rain: \(maxRainLastHour["value"] as! Double == 0.0 ? "-" : "\(maxRainLastHour["value"]!) mm")
        """
    }
}
