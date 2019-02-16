//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Hessa Mohamed on 05/01/2019.
//  Copyright © 2019 Hessa Mohamed. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class AddLocationViewController:UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        locationTextField.delegate = self
        linkTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func Cancel(_ sender: Any) {
        locationTextField.text = ""
        linkTextField.text = ""
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        guard let location = locationTextField.text, location != "" else {
            let errorAlert = UIAlertController(title: "Error", message: "Location cannot be empty", preferredStyle: .alert )
            
            errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler:
                { _ in
                    return
            }))
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        guard let link = linkTextField.text, link != "", (link.hasPrefix("https://") || link.hasPrefix("http://")) else {
            let errorAlert = UIAlertController(title: "Error", message: "Link cannot be empty or must starts with 'https://' or 'http://'", preferredStyle: .alert )
            
            errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler:
                { _ in
                    return
            }))
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        StudentLocationInfo.newStudentLocation.mapString = location

        StudentLocationInfo.newStudentLocation.mediaURL = link
        
        geocodeCoordinates(location: StudentLocationInfo.newStudentLocation.mapString)
    }
    
    func geocodeCoordinates(location: String) {
        activityIndicator.startAnimating()
        CLGeocoder().geocodeAddressString(location) {
            (placemarks, error) in

            
            guard (error == nil) else {
                self.activityIndicator.isHidden = true

                let errorAlert = UIAlertController(title: "Error", message:  "Could not calculate coordinates. Check your internet connection.", preferredStyle: .alert )
                
                errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler:
                    { _ in
                        return
                }))
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            
            let placemark = placemarks?.first
            
            guard let placemarkLatitude = placemark?.location?.coordinate.latitude else {
                self.activityIndicator.isHidden = true
                let errorAlert = UIAlertController(title: "Error", message:  "Could not calculate latitude coordinate. Re-try location.", preferredStyle: .alert )
                
                errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler:
                    { _ in
                        return
                }))
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            
            StudentLocationInfo.newStudentLocation.latitude = placemarkLatitude
            
            guard let placemarkLongitude = placemark?.location?.coordinate.longitude else {
                self.activityIndicator.isHidden = true
                let errorAlert = UIAlertController(title: "Error", message:  "Could not calculate. Re-try location.", preferredStyle: .alert )
                
                errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler:
                    { _ in
                        return
                }))
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            
             StudentLocationInfo.newStudentLocation.longitude = placemarkLongitude
            self.activityIndicator.isHidden = true
            self.passDataToNextViewController()
        }
    }
    
    func passDataToNextViewController() {

            let addLocationMapVC = self.storyboard?.instantiateViewController(withIdentifier: "AddConfirmation") as! AddConfirmationViewController
            
            self.navigationController?.pushViewController(addLocationMapVC, animated: true)
    }

}
