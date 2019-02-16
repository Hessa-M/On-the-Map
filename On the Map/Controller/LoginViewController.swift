//
//  ViewController.swift
//  On the Map
//
//  Created by Hessa Mohamed on 17/12/2018.
//  Copyright © 2018 Hessa Mohamed. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func SignUp(_ sender: Any) {
        guard let url = URL(string: "https://auth.udacity.com/sign-up")
            else {
                return
        }
        UIApplication.shared.open(url)
    }
    
    @IBAction func LogIn(_ sender: Any) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
     
       if (email!.isEmpty) || (password!.isEmpty) {
            
            let requiredFieldAlert = UIAlertController (title: "Fill all fields", message: "Email and Password must be fill", preferredStyle: .alert)
            
            requiredFieldAlert.addAction(UIAlertAction (title: "OK", style: .default, handler:
             { _ in
                return
             }))
            
            self.present (requiredFieldAlert, animated: true, completion: nil)
            
        } else {
            
            UdacityAPI.login(email, password){
                (loginSuccess, key, error) in
                DispatchQueue.main.async {
                    
                    if error != nil {
                        let errorAlert = UIAlertController(title: "Erorr", message: "There was an error", preferredStyle: .alert )
                        
                        errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler:
                         { _ in
                            return
                         }))
                        self.present(errorAlert, animated: true, completion: nil)
                        return
                    }
                    
                    if loginSuccess {
                        
                        self.emailTextField.text = nil
                        self.passwordTextField.text = nil
                   
                        let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
         
                       self.present(tabBarController, animated: true, completion: nil)
                        
                    } else {
                        
                       let loginErrorAlert = UIAlertController(title: "Erorr Email or password", message: "incorrect email or password, please try again", preferredStyle: .alert )
         
                       loginErrorAlert.addAction(UIAlertAction (title: "Try again", style: .default, handler:
                       { _ in
                           return
                       }))
                       self.present(loginErrorAlert, animated: true, completion: nil)

                    }
                }}
       }
        //*/
    }
}

