//
//  TabBarViewController.swift
//  On the Map
//
//  Created by Hessa Mohamed on 19/01/2019.
//  Copyright © 2019 Hessa Mohamed. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController{
    
    var studentLocationData: StudentLocationData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUINavigation()
        getStudentLocation()
    }
    
    func setupUINavigation() {
        
        let customButton = UIButton(type: UIButton.ButtonType.custom)
        customButton.setImage(UIImage(named:"baseline_place_black_36pt"), for: UIControl.State.normal)
        customButton.addTarget(self, action: #selector(self.AddLocation(_:)), for: UIControl.Event.touchUpInside)

        let AddLocationButton  = UIBarButtonItem(customView: customButton)
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.Refresh(_:)))
        let logoutButton = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(self.LogOut(_:)))
        
        navigationItem.rightBarButtonItems = [AddLocationButton, refreshButton]
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc func AddLocation(_ sender: Any) {
       let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocationNavigation") as! UINavigationController
       present(navController, animated: true, completion: nil)
    }
    
    @objc func Refresh(_ sender: Any) {
        DispatchQueue.main.async {
           self.getStudentLocation()
        }
    }
    
    @objc func LogOut(_ sender: Any) {
        
        UdacityAPI.logout(){
            (logoutSuccess, error) in
            DispatchQueue.main.async {
                
                if error != nil {
                    let errorAlert = UIAlertController(title: "Erorr", message: "Cannot Logout, There was an error", preferredStyle: .alert )
                    
                    errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler:
                        { _ in
                            return
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                    return
                }
                
                if logoutSuccess {
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    
                    let logoutErrorAlert = UIAlertController(title: "Error Logout", message: "Cannot logout, please try again", preferredStyle: .alert )
                    
                    logoutErrorAlert.addAction(UIAlertAction (title: "Try again", style: .default, handler:
                        { _ in
                            return
                    }))
                    self.present(logoutErrorAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    func getStudentLocation(){
        
        ParseAPI.getStudentLocations { (data, error) in
            
           if error != nil {
                let errorAlert = UIAlertController(title: "Error", message: "No internet connection found", preferredStyle: .alert )
                
                errorAlert.addAction(UIAlertAction (title: "Try again", style: .default, handler:
                    { _ in
                        return
                }))
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            
            guard let data = data else {
                let errorAlert = UIAlertController(title: "Error", message: "No internet connection found", preferredStyle: .alert )
                
                errorAlert.addAction(UIAlertAction (title: "Try again", style: .default, handler:
                    { _ in
                        return
                }))
                self.present(errorAlert, animated: true, completion: nil)

                return
            }
            
            guard data.studentLocations.count > 0 else {
                let errorAlert = UIAlertController(title: "Error", message: "No Data found", preferredStyle: .alert )
                
                errorAlert.addAction(UIAlertAction (title: "Try again", style: .default, handler:
                    { _ in
                        return
                }))
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            
            DispatchQueue.main.async {
                self.studentLocationData = data
            }
        }
    }
}
