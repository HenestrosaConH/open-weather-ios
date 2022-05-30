//
//  TownViewController.swift
//  OpenWeatherIOS
//
//  Created by JC on 25/5/22.
//

import UIKit
import MapKit

class TownViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let viewModel = TownViewModel()
    let countriesList = CountriesList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "OpenWeather"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBy))
        bind()
    }
    
    @objc func searchBy() {
        let ac = UIAlertController(title: "Search town by", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Name", style: .default) {_ in
            self.promptForFilter(type: "town", filter: SearchFilter.town)
        })
        ac.addAction(UIAlertAction(title: "ZIP code", style: .default) {_ in
            self.promptForFilter(type: "ZIP code", filter: SearchFilter.zipCode)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    private func bind() {
        viewModel.refreshData = { [weak self] () in
            if let annotations = self?.viewModel.annotations {
                // we only add the location that the user input
                DispatchQueue.main.async {
                    // Removing the existing annotations to avoid filling the map with them
                    let allAnnotations = self?.mapView.annotations
                    if let toRemove = allAnnotations {
                        self?.mapView.removeAnnotations(toRemove)
                    }
                    
                    // Only adding the first one. The rest are added when tapping on the original one
                    self?.mapView.addAnnotation(annotations[0])
                    self?.mapView.showAnnotations([annotations[0]], animated: true)
                }
            } else if let errorMessage = self?.viewModel.errorMessage {
                self?.displayAsyncAlert(title: "Error", message: errorMessage)
            }
        }
    }
    
    /**
     Prompts an alert controller to the user when the search button is tapped for typing the ZIP code or city
     */
    func promptForFilter(type: String, filter: SearchFilter) {
        let ac = UIAlertController(title: "Enter \(type)", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Search", style: .default) {
            [weak ac] _ in
            
            guard let input = ac?.textFields?[0].text?.lowercased() else { return }
            
            var parameters: [String : String]!
            switch filter {
            case .town:
                let escapedName = input.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
                parameters = [
                    "q": escapedName ?? "",
                    "units": "metric",
                ]
            case .zipCode:
                parameters = [
                    "zip": "\(input)",
                    "units": "metric",
                ]
            }
            
            self.viewModel.retrieveTownsWeather(parameters: parameters)
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func displayAsyncAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Stats", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
}

extension TownViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countriesList.countries.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countriesList.countries[row]["name"]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.countriesList.countries[row]["code"]
    }
}

extension TownViewController: MKMapViewDelegate {
    
    /**
     Part of the MKMapViewDelegate. We ensure that the shown annotation is a Town in order to handle it.
     
     - Parameter mapView: Map view in which we will show the places selected by the user.
     - Parameter annotation: Pin to be rendered
     
     - Returns: Pin to show.
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is TownAnnotation else { return nil }
        
        let identifier = "TownAnnotation"
        
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
        guard let pin = view.annotation as? TownAnnotation else { return }
        
        let title = pin.title
        let info = pin.info
        
        let ac = UIAlertController(title: title, message: info, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? TownAnnotation else { return }
        
        let annotationCount = mapView.annotations
            .filter { $0 is TownAnnotation }
            .count
        
        // If only the original pin is being showed, then we add the rest
        if annotation.isOriginal && annotationCount == 1 {
            if let annotations = viewModel.annotations {
                for annotation in annotations {
                    if !annotation.isOriginal {
                        DispatchQueue.main.async {
                            mapView.addAnnotation(annotation)
                        }
                    }
                }
                mapView.showAnnotations(annotations, animated: true)
                displayAsyncAlert(title: "Stats", message: viewModel.statsMessage ?? "Couldn't find the stats")
            }
        }
    }
}
