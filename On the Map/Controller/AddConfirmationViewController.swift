//
//  AddConfirmationViewController.swift
//  On the Map
//
//  Created by Hessa Mohamed on 05/01/2019.
//  Copyright © 2019 Hessa Mohamed. All rights reserved.
//

import UIKit
import MapKit

class AddConfirmationViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    var location: StudentLocationInfo?
    
    var newLocation = StudentLocationInfo.newStudentLocation.mapString
    var newURL = StudentLocationInfo.newStudentLocation.mediaURL
    var newLatitude = StudentLocationInfo.newStudentLocation.latitude
    var newLongitude = StudentLocationInfo.newStudentLocation.longitude
    var userInfo = UserInfo()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNewStudentLocation()
    }
    
    @IBAction func submitStudentLocationInfo(_ sender: Any) {
        UdacityAPI.getUserInfo { (userInfoData, err) in
            if err != nil{
                let errorAlert = UIAlertController(title: "Error", message:  "There was an error posting new location. Please try again later", preferredStyle: .alert )
                
                errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler:
                    { _ in
                        return
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
            
            guard let userData = userInfoData else {
                let errorAlert = UIAlertController(title: "Error", message: "No internet connection found", preferredStyle: .alert )
                
                errorAlert.addAction(UIAlertAction (title: "Try again", style: .default, handler:
                    { _ in
                        return
                }))
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            
            self.userInfo = userData
      
    ParseAPI.postStudentLocations(newMapString: self.newLocation, newMediaURL:  self.newURL, newLatitude:  self.newLatitude, newLongitude:  self.newLongitude, uniqueKey: self.userInfo.key!, firstName: self.userInfo.firstName!,lastName: self.userInfo.lastName!) { err  in
            if err == nil{

                self.dismiss(animated: true, completion: nil)

            } else {
                let errorAlert = UIAlertController(title: "Error", message:  "There was an error posting new location.", preferredStyle: .alert )
                
                errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler:
                    { _ in
                        return
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
            
      }
    }
    
    func setupNewStudentLocation(){
        
        let PinAnnotation = MKPointAnnotation()

        let lat = CLLocationDegrees(newLatitude)
        let long = CLLocationDegrees(newLongitude)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        

        PinAnnotation.coordinate = coordinate
        PinAnnotation.title = newURL

        mapView.addAnnotation(PinAnnotation)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
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
