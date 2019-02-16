//
//  MapViewController.swift
//  On the Map
//
//  Created by Hessa Mohamed on 29/12/2018.
//  Copyright © 2018 Hessa Mohamed. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: TabBarViewController, MKMapViewDelegate {
    
    @IBOutlet weak var MapView: MKMapView!
    
   override var studentLocationData: StudentLocationData? {
        didSet {
            displayAnnotations()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func displayAnnotations(){

        guard let locations = studentLocationData?.studentLocations else { return }

        MapView.removeAnnotations(MapView.annotations)
        
        var newAnnotations = [MKPointAnnotation]()

        for locations in locations {
            let latitudeLocation = CLLocationDegrees(locations.latitude ?? 0)
            let longitudeLocation = CLLocationDegrees(locations.longitude ?? 0)
            
            let coordinate = CLLocationCoordinate2D(latitude: latitudeLocation, longitude: longitudeLocation)
            
            let first = locations.firstName!
            let last = locations.lastName!
            let mediaURL = locations.mediaURL!
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(String(describing: first)) \(String(describing: last))"
            annotation.subtitle = mediaURL
            
            newAnnotations.append(annotation)
        }
        MapView.addAnnotations(newAnnotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "annotation"
        var pinView: MKPinAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            pinView = dequeuedView
        } else {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView.canShowCallout = true
            pinView.pinTintColor = .red
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            } else{

                let errorAlert = UIAlertController(title: "Invalid URL", message: "Could not open URL", preferredStyle: .alert )
                
                errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler:
                    { _ in
                        return
                }))
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
        }
    }
    
}
