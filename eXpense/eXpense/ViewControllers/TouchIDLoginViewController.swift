//
//  TouchIDLoginViewController.swift
//  eXpense
//
//  Created by Shawn Moore on 2/5/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIDLoginViewController: UIViewController {

    var authModel: Authentication?
    
    let context = LAContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        authModel = appDelegate.getAuthenticationModel()
    }
    
    override func viewDidAppear(animated: Bool) {
        if authModel != nil
        {
            let (usernameValue, usernameErrorCode) = authModel!.retrieveUsername()
            
            if(usernameErrorCode == authModel!.errSecSuccess)
            {
                let (passwordValue, passwordErrorCode) = authModel!.retrievePassword()
                
                if(passwordErrorCode == authModel!.errSecSuccess)
                {
                    let reason = "Please authenticate with Touch ID to access \(usernameValue!)'s account"
                    var error: NSError? = nil
                    
                    [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                        if success
                        {
                            if self.authModel!.authenticate(usernameValue!, password: passwordValue!)
                            {
                                self.performSegueWithIdentifier("touchToDashboard", sender: self)
                            } else {
                                self.performSegueWithIdentifier("touchToLogin", sender: self)
                            }
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.performSegueWithIdentifier("touchToLogin", sender: self)
                            })
                        }
                    })]
                } else {
                    performSegueWithIdentifier("touchToLogin", sender: self)
                }
            } else {
                performSegueWithIdentifier("touchToLogin", sender: self)
            }
        } else {
            performSegueWithIdentifier("touchToLogin", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
