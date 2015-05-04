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

    override func viewDidAppear(animated: Bool) {
        isConnectedToNetwork()
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
    
    func isConnectedToNetwork(){
        
        var status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }
        if !status {
            var alert = UIAlertController(title: "No Data Connection", message: "You must be connected to the Internet. Please, connect and reopen eXpense.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                exit(0)
            }))
            presentViewController(alert, animated: true, completion: nil)
            //exit(0)
        }
    }
    
}
