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
        
        title = "OpenWeather"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(promptForFilter))
    }
    
    /**
     Prompts an alert controller to the user when the search button is tapped for typing the ZIP code or city
     */
    @objc func promptForFilter() {
        let ac = UIAlertController(title: "Enter city", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Search", style: .default) {
            [weak ac] _ in
            
            guard let filter = ac?.textFields?[0].text?.lowercased() else { return }
            let url = "https://api.openweathermap.org/data/2.5/weather?q=\(filter)&appid=34a31e8efb2b36328928533c63e9dec1"
            
            Connection.getTownWeather(from: url, completion: {
                success, townWeather, error in
                
                if success {
                    let pin = Pin(title: townWeather!.name, coordinate: CLLocationCoordinate2D(latitude: townWeather!.coord.lat, longitude: townWeather!.coord.lon), info: "foo")
                    let northPin = Pin(title: townWeather!.name, coordinate: CLLocationCoordinate2D(latitude: townWeather!.coord.lat, longitude: townWeather!.coord.lon), info: "foo")
                    let southPin = Pin(title: townWeather!.name, coordinate: CLLocationCoordinate2D(latitude: townWeather!.coord.lat, longitude: townWeather!.coord.lon), info: "foo")
                    let eastPin = Pin(title: townWeather!.name, coordinate: CLLocationCoordinate2D(latitude: townWeather!.coord.lat, longitude: townWeather!.coord.lon), info: "foo")
                    let westPin = Pin(title: townWeather!.name, coordinate: CLLocationCoordinate2D(latitude: townWeather!.coord.lat, longitude: townWeather!.coord.lon), info: "foo")
                    
                    self.mapView.addAnnotation(pin)
                } else {
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            })
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    /**
     Part of the MKMapViewDelegate. We ensure that the shown annotation is a Town in order to handle it.
     
     - Parameter mapView: Map view in which we will show the places selected by the user.
     - Parameter annotation: Pin to be rendered
     
     - Returns: Pin to show.
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Pin else { return nil }
        
        let identifier = "Pin"
        
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
            // It can reuse a view so it will update it to load data of a different annotation.
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
        guard let pin = view.annotation as? Pin else { return }
        
        let title = pin.title
        let info = pin.info
        
        let ac = UIAlertController(title: title, message: info, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

}
