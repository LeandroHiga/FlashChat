//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    //Just before the view shows up, hide de navigation bar because it's not necessary
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) //Best practice to call super whenever we override any function from the super class
        navigationController?.isNavigationBarHidden = true
    }
    
    //Just before the vie disappear and the next screen shows up, unhide the navigation bar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated) //Best practice to call super whenever we override any function from the super class
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = K.appName
        titleLabel.adjustsFontSizeToFitWidth = true
        
        //        titleLabel.text = ""
        //        var charIndex = 0.0
        //        let titleText = "⚡️FlashChat"
        //
        //        for letter in titleText {
        //            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
        //                self.titleLabel.text?.append(letter)
        //            }
        //            charIndex += 1
    }
    
}
