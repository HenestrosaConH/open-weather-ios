//
//  TownWeatherViewModel.swift
//  OpenWeatherIOS
//
//  Created by JC on 27/5/22.
//

import MapKit

class TownViewModel {
    
    // Links the view with its view model
    var refreshData = { () -> () in }
    
    var annotations: [TownAnnotation]? {
        didSet {
            refreshData()
        }
    }
    
    lazy var stats = Stats()
    var statsMessage: String?
    
    var errorMessage: String? {
        didSet {
            refreshData()
        }
    }
    
    private let townUrl = TownUrl()
    
    /**
     Creates a TownAnnotation from the name of a town input by the user. From the given town, we get the relative towns that are 200 km away from it.
     
     - Parameter inputTown: Name of the town introduced by the user.
     */
    func retrieveTownsWeather(parameters: [String : String]) {
        var mutableParameters = parameters
        mutableParameters["appid"] = townUrl.apiKey
        let url = townUrl.getUrl(path: townUrl.paths["data"]!, parameters: mutableParameters)
        
        TownData.shared.getTownWeather(url: url) {
            success, townWeather, error in
            
            if success {
                // Reset of Stats
                self.stats = Stats()
                
                if let weather = townWeather {
                    let inputTownCoords = CLLocationCoordinate2D(latitude: weather.coord.lat, longitude: weather.coord.lon)
                    let inputTownAnnotation = TownAnnotation(title: weather.name, coordinate: inputTownCoords, info: weather.getInfo(), isOriginal: true)
                    self.stats.updateStats(townWeather: weather)
                    self.statsMessage = self.stats.toString()
                    
                    
                    // Re-initializing the array to avoid filling it with past annotations
                    self.annotations = [inputTownAnnotation]
                    
                    let relativesCoords = [
                        weather.getRelativeLocation(north: 200, west: 0),    // north
                        weather.getRelativeLocation(north: -200, west: 0),   // south
                        weather.getRelativeLocation(north: 0, west: 200),    // east
                        weather.getRelativeLocation(north: 0, west: -200)    // west
                    ]
                    
                    for relativeCoords in relativesCoords {
                        self.appendTownWeather(with: relativeCoords)
                    }
                } else {
                    self.errorMessage = "Unexpected error getting the data of the input town."
                }
            } else {
                self.errorMessage = error?.localizedDescription
            }
        }
    }
    
    
    /**
     Handles the response of the data layer. Gets the name of the town from its coordinates.
     
     - Parameter coordinates: Coordinates of the town to find.
     - Parameter completion: Returns the TownName obtained from the coordinates.
     */
    func retrieveTownName(coordinates: CLLocationCoordinate2D, completion: @escaping (TownName?) -> Void) {
        let parameters = [
            "lat": String(coordinates.latitude),
            "lon": String(coordinates.longitude),
            "appid": townUrl.apiKey
        ]
        let url = townUrl.getUrl(path: townUrl.paths["geo"]!, parameters: parameters)
        
        TownData.shared.getTownName(url: url, completion: {
            success, townName, error in
            
            if success {
                completion(townName!)
            } else {
                self.errorMessage = error?.localizedDescription
            }
        })
    }
    
    /**
     Gets and appends the TownWeather with certain coordinates to the annotations array in order to be shown on the map.
     
     - Parameter coordinates: Coordinates of the town to find and append.
     */
    private func appendTownWeather(with coordinates: CLLocationCoordinate2D) {
        self.retrieveTownName(coordinates: coordinates) {
            townName in
         
            guard let name = townName?.name else { return }
            
            let parameters = [
                "q": name,
                "units": "metric",
                "appid": self.townUrl.apiKey
            ]
            let url = self.townUrl.getUrl(path: self.townUrl.paths["data"]!, parameters: parameters)
            
            TownData.shared.getTownWeather(url: url) {
                success, townWeather, error in
                
                if success {
                    if let weather = townWeather {
                        let annotation = TownAnnotation(title: name, coordinate: coordinates, info: weather.getInfo())
                        self.stats.updateStats(townWeather: weather)
                        self.statsMessage = self.stats.toString()
                        self.annotations?.append(annotation)
                    } else {
                        self.errorMessage = "Unexpected error getting the data of the input town."
                    }
                } else {
                    self.errorMessage = error?.localizedDescription
                }
            }
        }
    }
}
