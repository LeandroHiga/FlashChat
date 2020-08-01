//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        //Check if both fields are not nil
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                
                if let e = error { //If there is an error, show alert with message
                    let registerError = e.localizedDescription //Description of the error
                    
                    // Create the erro message
                    let message = registerError
                    
                    // Create UIAlertController
                    // Upper body of the notification
                    let alert = UIAlertController(title: "Registration could not be processed", message: message, preferredStyle: .alert)
                    
                    // Create UIAlertAction
                    // Button (the one that user press)
                    // The handler code is executed when the button is tapped
                    let action = UIAlertAction(title: "OK", style: .default, handler: {
                        action in
                        
                    })
                    
                    //Add action to the alert
                    alert.addAction(action)
                    
                    // Present alert
                    self.present(alert, animated: true, completion: nil)
                } else {
                    //Navigate to the ChatViewController
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
        
    }
    
}

