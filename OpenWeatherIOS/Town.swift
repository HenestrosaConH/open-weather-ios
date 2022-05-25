//
//  Capital.swift
//  OpenWeatherIOS
//
//  Created by JC on 25/5/22.
//

import UIKit
import MapKit

class Town: NSObject, MKAnnotation  {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
