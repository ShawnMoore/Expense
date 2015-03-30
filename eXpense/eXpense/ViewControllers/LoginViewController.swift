//
//  LoginViewController.swift
//  eXpense
//
//  Created by Shawn Moore on 2/5/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit
import QuartzCore

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var model: Model?
    var authModel: Authentication?
    
    let transitionManager = TransitionManager()
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backgroudImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        model = appDelegate.getModel()
        authModel = appDelegate.getAuthenticationModel()

        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor.whiteColor().CGColor
        emailTextField.layer.cornerRadius = 5.0
        
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor.whiteColor().CGColor
        passwordTextField.layer.cornerRadius = 5.0
        
        loginButton.layer.cornerRadius = 5.0
        
        var username = authModel?.retrieveUsername()
        
        if (username?.errorCode == authModel?.errSecSuccess) {
           emailTextField.text = username!.value
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.logoImageView.image = UIImage(named: "eXpenseLogoGray")
            self.backgroudImageView.image = UIImage(named: "eXpenseBackgroundFaded")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        
        let boolResults = authModel?.authenticate(emailTextField.text, password: passwordTextField.text)
        
        if boolResults!
        {
            performSegueWithIdentifier("loginToDashboard", sender: self)
        }
        else
        {
            let animation = CABasicAnimation(keyPath: "position")
            let view = self.view.layer
            animation.duration = 0.085
            animation.repeatCount = 1
            animation.autoreverses = true
            animation.fromValue = NSValue(CGPoint: CGPointMake(self.view.center.x - 9, self.view.center.y))
            animation.toValue = NSValue(CGPoint: CGPointMake(self.view.center.x + 9, self.view.center.y))
            view.addAnimation(animation, forKey: "position")
            
            passwordTextField.text = ""
        }
        
    }
    
    @IBAction func createAccountAction(sender: AnyObject) {
        performSegueWithIdentifier("loginToSignUp", sender: self)
    }
    
    @IBAction func forgotPassword(sender: AnyObject) {
        
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func dismissKeyboardBySwiping(sender: AnyObject) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        if textField == passwordTextField {
            self.loginAction(self)
            passwordTextField.resignFirstResponder()
        }
            
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier! == "loginToSignUp"
        {
            let toViewController = segue.destinationViewController as UIViewController
    
            toViewController.transitioningDelegate = self.transitionManager
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
