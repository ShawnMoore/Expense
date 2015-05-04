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
    
    let transitionManager = TransitionManager()
    let context = LAContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        authModel = appDelegate.getAuthenticationModel()
        
        if authModel != nil
        {
            let (usernameValue, usernameErrorCode) = authModel!.retrieveUsername()
            
            if(usernameErrorCode == authModel!.errSecSuccess)
            {
                let (passwordValue, passwordErrorCode) = authModel!.retrievePassword()
                
                if(passwordErrorCode == authModel!.errSecSuccess)
                {
                    let reason = "Please authenticate with Touch ID to access your account"
                    var error: NSError? = nil
                    
                    [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                        if success
                        {
                            if self.authModel!.authenticate(usernameValue as! String, password: passwordValue as! String)
                            {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.performSegueWithIdentifier("touchToDashboard", sender: self)
                                })
                            } else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.performSegueWithIdentifier("touchToLogin", sender: self)
                                })
                            }
                        } else {
                            
                            if evalPolicyError?.code == LAError.UserCancel.rawValue {
                                //println("Canceled by user")
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.performSegueWithIdentifier("backToLanding", sender: self)
                                })
                            } else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.performSegueWithIdentifier("touchToLogin", sender: self)
                                })
                            }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController as! UIViewController
        
        toViewController.transitioningDelegate = self.transitionManager
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
