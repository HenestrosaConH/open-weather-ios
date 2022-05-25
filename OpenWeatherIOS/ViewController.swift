//
//  ViewController.swift
//  OpenWeatherIOS
//
//  Created by JC on 25/5/22.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    /**
     Part of the MKMapViewDelegate. We ensure that the shown annotation is a Town in order to handle it.
     
     - Parameter mapView: Map view in which we will show the places selected by the user.
     - Parameter annotation: Pin to be rendered
     
     - Returns: Pin to show.
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Town else { return nil }
        
        let identifier = "Town"
        
        // Dequeues a pin from the map view's pool of unused views and stores it in a var.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            // If it isn't able to find a reusable pin, create a new one
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            // Displays the popup when we tap on the pin
            annotationView?.canShowCallout = true
            
            // Stylizes the button with a small blue "i" symbol inside a blue circle.
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            // It can reuse a view so update it to load data of a different annotation.
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    /**
     Part of the MKMapViewDelegate. Handles the event when the user taps on the pin to display more information.
     
     - Parameter mapView: Map view in which the pins are.
     - Parameter view: Pin view
     - Parameter control: The control that was tapped. Not used.
     */
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let town = view.annotation as? Town else { return }
        
        let townName = town.title
        let townInfo = town.info
        
        let ac = UIAlertController(title: townName, message: townInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

}

