//
//  Authentication.swift
//  eXpense
//
//  Created by Shawn Moore on 2/21/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit
import LocalAuthentication

class Authentication: NSObject {
   
    //MARK: Class Variables
    let service = NSBundle.mainBundle().bundleIdentifier!
    /// The keychain key to the Username
    let usernameKey = "Username"
    /// The keychain key to the Password
    let passwordKey = "Password"
    
    let context = LAContext()
    
    
    //MARK: Keychain Functions
    /**
        Retrieves the Username from the Device's Keychain
    
        :returns: - value: The optional value of the returned username
                  - errorCode: Int value of the error code returned from the keychain api
    */
    func retrieveUsername() -> (value: NSString?, errorCode: Int)
    {
        var value: NSString? = nil
        
        let keyToSearchFor = usernameKey
        
        let query = [
            kSecClass as NSString :
                kSecClassGenericPassword as NSString,
            kSecAttrService as NSString : service,
            kSecAttrAccount as NSString : keyToSearchFor,
            kSecReturnData as NSString : kCFBooleanTrue
            ] as NSDictionary
        
        var returnedData: Unmanaged<AnyObject>? = nil
        let results = Int(SecItemCopyMatching(query, &returnedData))
        
        if results == Int(errSecSuccess){
            
            let data = returnedData!.takeRetainedValue() as NSData
            
            value = NSString(data: data, encoding: NSUTF8StringEncoding)
            
        }
        
        return (value, results)
    }
    
    /**
        Retrieves the Password from the Device's Keychain
    
        :returns: - value: The optional value of the returned password
                  - errorCode: Int value of the error code returned from the keychain api
    */
    func retrievePassword() -> (value: NSString?, errorCode: Int)
    {
        var value: NSString? = nil
        
        let keyToSearchFor = passwordKey
        
        let query = [
            kSecClass as NSString :
                kSecClassGenericPassword as NSString,
            kSecAttrService as NSString : service,
            kSecAttrAccount as NSString : keyToSearchFor,
            kSecReturnData as NSString : kCFBooleanTrue
            ] as NSDictionary
        
        var returnedData: Unmanaged<AnyObject>? = nil
        let results = Int(SecItemCopyMatching(query, &returnedData))
        
        if results == Int(errSecSuccess){
            
            let data = returnedData!.takeRetainedValue() as NSData
            
            value = NSString(data: data, encoding: NSUTF8StringEncoding)
            
        }
        
        return (value, results)
    }
    
    /**
        Inserts or updates the username within the Device's Keychain
    
        :param: usernameValue The string value of the username to be inserted
    
        :returns: - insertStatus: Int value of the error code returned from the keychain api when inserting the username
                  - errorCode: Possible Int value of the error code returned from the keychain api when updating the username
    */
    func insertUsername(usernameValue: String) -> (insertStatus: Int, updateStatus: Int?)
    {
        let key = usernameKey
        
        let value = usernameValue
        let valueData = value.dataUsingEncoding(NSUTF8StringEncoding,
            allowLossyConversion: false)
        
        let secItem = [
            kSecClass as NSString :
                kSecClassGenericPassword as NSString,
            kSecAttrService as NSString : service,
            kSecAttrAccount as NSString : key,
            kSecValueData as NSString : valueData!
            ] as NSDictionary
        
        var result: Unmanaged<AnyObject>? = nil
        let insertStatus = Int(SecItemAdd(secItem, &result))
        var updateStatus:Int? = nil
        
        if insertStatus == Int(errSecDuplicateItem)
        {
            let update = [
                kSecValueData as NSString : valueData!,
                kSecAttrComment as NSString : "Updated Username"
                ] as NSDictionary
            
            updateStatus = Int(SecItemUpdate(secItem, update))
        }
        
        return (insertStatus, updateStatus)
    }
    
    /**
        Inserts or updates the password within the Device's Keychain
    
        :param: passwordValue The string value of the password to be inserted
    
        :returns: - insertStatus: Int value of the error code returned from the keychain api when inserting the password
                  - errorCode: Possible Int value of the error code returned from the keychain api when updating the password
    */
    func insertPassword(passwordValue: String) -> (insertStatus: Int, updateStatus: Int?)
    {
        let key = passwordKey
        
        let value = passwordValue
        let valueData = value.dataUsingEncoding(NSUTF8StringEncoding,
            allowLossyConversion: false)
        
        let secItem = [
            kSecClass as NSString :
                kSecClassGenericPassword as NSString,
            kSecAttrService as NSString : service,
            kSecAttrAccount as NSString : key,
            kSecValueData as NSString : valueData!
            ] as NSDictionary
        
        var result: Unmanaged<AnyObject>? = nil
        let insertStatus = Int(SecItemAdd(secItem, &result))
        var updateStatus:Int? = nil
        
        if insertStatus == Int(errSecDuplicateItem)
        {
            let update = [
                kSecValueData as NSString : valueData!,
                kSecAttrComment as NSString : "Updated Password"
                ] as NSDictionary
            
            updateStatus = Int(SecItemUpdate(secItem, update))
        }
        
        return (insertStatus, updateStatus)
    }
    
    /**
        Deletes the Username from the Device's Keychain
    
        :returns: - foundStatus: Int value of the error code returned from the keychain api when locating the username
                  - deleteStatus: Possible Int value of the error code returned from the keychain api when deleting the username
    */
    func deleteUsername() -> (foundStatus: Int, deleteStatus: Int?)
    {
        let keyToSearchFor = usernameKey
        
        let query = [
            kSecClass as NSString :
                kSecClassGenericPassword as NSString,
            
            kSecAttrService as NSString : service,
            kSecAttrAccount as NSString : keyToSearchFor,
            ] as NSDictionary
        
        
        var result: Unmanaged<AnyObject>? = nil
        let foundExisting = Int(SecItemCopyMatching(query, &result))
        var deleted: Int? = nil
        
        if foundExisting == Int(errSecSuccess){
            deleted = Int(SecItemDelete(query))
        }
        
        return (foundExisting, deleted)
    }
    
    /**
        Deletes the Password from the Device's Keychain
    
    :returns: - foundStatus: Int value of the error code returned from the keychain api when locating the password
              - deleteStatus: Possible Int value of the error code returned from the keychain api when deleting the password
    */
    func deletePassword() -> (foundStatus: Int, deleteStatus: Int?)
    {
        let keyToSearchFor = passwordKey
        
        let query = [
            kSecClass as NSString :
                kSecClassGenericPassword as NSString,
            
            kSecAttrService as NSString : service,
            kSecAttrAccount as NSString : keyToSearchFor,
            ] as NSDictionary
        
        
        var result: Unmanaged<AnyObject>? = nil
        let foundExisting = Int(SecItemCopyMatching(query, &result))
        var deleted: Int? = nil
        
        if foundExisting == Int(errSecSuccess){
            deleted = Int(SecItemDelete(query))
        }
        
        return (foundExisting, deleted)
    }
    
    //MARK: Touch ID Functions
    /**
        Returns wether or not the device can use touchID
    
        :returns: - avaiable: bool of wether touchId is avaiable
                  - error: Possible NSError value returned from the Local authentication api
    */
    func isTouchIDAvaiable() -> (avaiable: Bool, error: NSError?)
    {
        var error: NSError?
        
        let result = context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error)
        
        return (result, error)
    }
    
    //FIXME: This cannot work. Has to be preformed in the class that uses this...
    func touchAuthenticate(username: String) -> (success: Bool, error: NSError?)
    {
    let reason = "Please authenticate with Touch ID to access \(username)'s account"
    var results: Bool = false
    var error: NSError? = nil
    
    /*[context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
    
    results = success ? true : false
    
    println("Within: \(results)")
    
    error = evalPolicyError
    
    })]*/
    
    return (results, error)
    
    }
    
    //MARK: Server Authentication Functions
    /**
        Authenticates the information the user typed in with the server
    
        :param: username The string value of the username to be checked
        :param: password The string value of the password to be checked
    
        :returns: bool on whether or not the user was authenticated
    */
    func authenticate(username: String, password: String) -> Bool
    {
        var results: Bool = false
        
        let correctUsername = "ShawnMoore"
        let correctPassword = "password1"
        
        results = ((correctUsername == username) && (correctPassword == password)) ? true : false
        
        return results
    }
}
