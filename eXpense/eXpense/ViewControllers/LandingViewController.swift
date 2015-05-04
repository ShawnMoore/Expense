//
//  LandingViewController.swift
//  eXpense
//
//  Created by Shawn Moore on 2/5/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    let transitionManager = TransitionManager()
    var authModel: Authentication?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        authModel = appDelegate.getAuthenticationModel()

        authModel?.deleteBearer()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        
        if authModel != nil
        {
            if authModel!.isTouchIDAvaiable().avaiable
            {
                if authModel!.keychainUsernameAndPasswordExist()
                {
                    performSegueWithIdentifier("splashToTouch", sender: self)
                }
            }
            
        }
        
        performSegueWithIdentifier("splashToLogin", sender: self)
    }
    
    @IBAction func signUpButton(sender: AnyObject) {
        performSegueWithIdentifier("splashToSignUp", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController as! UIViewController
        
        toViewController.transitioningDelegate = self.transitionManager
        
    }
    
    @IBAction func unwindSegue(sender: UIStoryboardSegue) {
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
