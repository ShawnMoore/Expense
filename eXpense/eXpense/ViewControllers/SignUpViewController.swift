//
//  SignUpViewController.swift
//  eXpense
//
//  Created by Shawn Moore on 2/5/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    var activeField: UITextField? = nil;
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    var centerYConstraintConstant: CGFloat? = nil
    let textfieldOffset:CGFloat = 15
    
    let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerForKeyboardNotifications()
        scrollView.keyboardDismissMode = .Interactive
        
        for textField in textFields {
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.whiteColor().CGColor
            textField.layer.cornerRadius = 5.0
        }
        
        createAccountButton.layer.cornerRadius = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
        scrollView.scrollEnabled = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
        scrollView.scrollEnabled = false
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name:UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    
    func keyboardWasShown(aNotification: NSNotification) {
        centerYConstraintConstant = centerYConstraint.constant
        
        if let info = aNotification.userInfo {
            var kbSize: CGSize = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue().size
            
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            var aRect: CGRect = self.view.frame;
            aRect.size.height -= kbSize.height
            
            if(!CGRectContainsPoint(aRect, activeField!.frame.origin)){
                if let currentConstant = centerYConstraintConstant {
                    centerYConstraint.constant = currentConstant + textfieldOffset
                }
            }
        }
    }
    
    func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        centerYConstraint.constant = centerYConstraintConstant!
    }
    
    @IBAction func dismissKeyboardTapGesture(sender: AnyObject) {
        activeField?.resignFirstResponder()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            let toViewController = segue.destinationViewController as UIViewController
            
            toViewController.transitioningDelegate = self.transitionManager

    }    
    
}
