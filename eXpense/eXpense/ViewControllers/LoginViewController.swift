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
        
        loginButton.layer.cornerRadius = 2.0
        
        var username = authModel?.retrieveUsername()
        
        if (username?.errorCode == authModel?.errSecItemNotFound) {
            println("Item not found")
        }
        
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
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func dismissKeyboardBySwiping(sender: AnyObject) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func forgotPassword(sender: AnyObject) {

    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return 0
    }
}
