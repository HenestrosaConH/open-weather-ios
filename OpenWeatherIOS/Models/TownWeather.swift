//
//  Town.swift
//  OpenWeatherIOS
//
//  Created by JC on 25/5/22.
//

struct TownWeather: Decodable  {
    let coord: Coord
    let main: Main
    let wind: Wind
    let name: String
    let cod: Int
    //var coordinate: CLLocationCoordinate2D

    /*
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }*/
}

/*
 JSON Example:
 -------------
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
