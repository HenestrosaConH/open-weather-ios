//
//  Pin.swift
//  OpenWeatherIOS
//
//  Created by JC on 26/5/22.
//

import MapKit
import UIKit

// We need to conformance to NSObjectProtocol in order to conform the MKAnnotation protocol
class Pin: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
