//
//  LoginViewController.swift
//  eXpense
//
//  Created by Shawn Moore on 2/5/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit
import QuartzCore

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor.whiteColor().CGColor
        emailTextField.layer.cornerRadius = 5.0
        
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor.whiteColor().CGColor
        passwordTextField.layer.cornerRadius = 5.0
        
        loginButton.layer.cornerRadius = 2.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
