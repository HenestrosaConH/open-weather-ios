//
//  Pin.swift
//  OpenWeatherIOS
//
//  Created by JC on 26/5/22.
//

import MapKit
import UIKit

// We need to conformance to NSObjectProtocol in order to conform the MKAnnotation protocol
class TownAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var isOriginal: Bool
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, isOriginal: Bool = false) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.isOriginal = isOriginal
    }
}
