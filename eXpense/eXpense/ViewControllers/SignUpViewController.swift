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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerForKeyboardNotifications()
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
        var kbSize: CGSize;
        
        if let info = aNotification.userInfo {
            var kbSize: CGSize = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue().size
            
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            /*
            //Turns out that this doesn't do anything
            
            var aRect: CGRect = self.view.frame;
            aRect.size.height -= kbSize.height;
            if (!CGRectContainsPoint(aRect, activeField!.frame.origin))
            {
                scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }*/
        }
    }
    
    func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @IBAction func dismissKeyboardTapGesture(sender: AnyObject) {
        activeField?.resignFirstResponder()
    }
    
}
