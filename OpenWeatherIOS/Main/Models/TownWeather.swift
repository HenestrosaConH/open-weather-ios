//
//  Town.swift
//  OpenWeatherIOS
//
//  Created by JC on 25/5/22.
//

import MapKit

struct TownWeather: Decodable  {
    let coord: Coord
    let main: Main
    let wind: Wind
    let rain: Rain?
    let name: String
    let cod: Int
    
    struct Coord: Decodable  {
        let lon: Double
        let lat: Double
    }

    struct Main: Decodable  {
        let temp: Double
        let humidity: Int
    }

    struct Wind: Decodable  {
        let speed: Double
    }

    struct Rain: Decodable {
        let lastHour: Double
        
        private enum CodingKeys : String, CodingKey {
            case lastHour = "1h"
        }
    }
    
    /**
     Gets the info of the TownWeather.
     
     - Returns: A String with the info to be displayed when tapping on the info button of a map's annotation
     */
    func getInfo() -> String {
        var rainString: String?
        if let safeRain = rain?.lastHour {
            rainString = String(format: "%.2f", safeRain)
        }
        
        return """
        Temperature: \(main.temp)ºC
        Humidity: \(main.humidity)%
        Wind speed: \(wind.speed) meter/sec
        Rain in the last hour: \(rainString ?? "-") mm
        """
    }
    
    /**
     Gets the relative locations from the town.
     
     - Parameter northDistance: Number of kilometers away from the north of the location to obtain.
     - Parameter westDistance: Number of kilometers away from the west of the location to obtain.
     
     - Returns: Coordinates of the relative location.
     */
    func getRelativeLocation(north northDistance: Double, west westDistance: Double) -> CLLocationCoordinate2D {
        let lat: CLLocationDegrees = coord.lat + northDistance / 110.574
        let lon: CLLocationDegrees = coord.lon + westDistance / (111.320 * cos(lat * .pi / 180))
         return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}


/*
JSON Example:
------------------------------------
{
    "coord": {
        "lon":-0.1257,
        "lat":51.5085
    },
    "weather":[{
        "id":800,
        "main":"Clear",
        "description":"clear sky",
        "icon":"01n"
    }],
    "base":"stations",
    "main":{
        "temp":286.56,
        "feels_like":286.07,
        "temp_min":285.4,
        "temp_max":287.67,
        "pressure":1018,
        "humidity":81
    },
    "visibility":10000,
    "wind":{
        "speed":0.45,
        "deg":268,
        "gust":2.68
    },
    "clouds":{
        "all":4
    },
    "dt":1653517441,
    "sys":{
        "type":2,
        "id":2019646,
        "country":"GB",
        "sunrise":1653450957,
        "sunset":1653508754
    },
    "timezone":3600,
    "id":2643743,
    "name":"London",
    "cod":200
}
*/
