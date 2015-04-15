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
    /// The keychain key to the Bearer
    let bearerKey = "Bearer"
    
    let context = LAContext()
    
    //MARK: Error Codes
    let errSecSuccess = 0                       //No error
    let errSecItemNotFound = -25300             //The item cannot be found
    let errSecUnimplemented = -4                //Function or operation not implemented
    let errSecParam = -50                       //One or more parameters passed to the function were not valid.
    let errSecAllocate = -108                   //Failed to allocate memory
    let errSecNotAvailable = -25291             //No trust results are avialable
    let errSecAuthFailed = -25293               //Authorization/Authentication failed
    let errSecDuplicateItem = -25299            //The item already exists
    let errSecInteractionNotAllowed = -25308    //Interaction with the Security Server is not allowed.
    let errSecDecode = -26275                   //Unable to decode the provided data.
    
    //MARK: Self Error Codes
    let errUnknown = -1                         //Unknown error
    
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
            
            let data = returnedData!.takeRetainedValue() as! NSData
            
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
            
            let data = returnedData!.takeRetainedValue() as! NSData
            
            value = NSString(data: data, encoding: NSUTF8StringEncoding)
            
        }
        
        return (value, results)
    }
    
    /**
        Retrieves the Bearer from the Device's Keychain
    
        :returns: - value: The optional value of the returned bearer
                  - errorCode: Int value of the error code returned from the keychain api
    */
    func retrieveBearer() -> (value: NSString?, errorCode: Int)
    {
        var value: NSString? = nil
        
        let keyToSearchFor = bearerKey
        
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
            
            let data = returnedData!.takeRetainedValue() as! NSData
            
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
        Inserts or updates the bearer within the Device's Keychain
    
        :param: bearerValue The string value of the bearer to be inserted
    
        :returns: - insertStatus: Int value of the error code returned from the keychain api when inserting the bear
                  - errorCode: Possible Int value of the error code returned from the keychain api when updating the bearer
    */
    func insertBearer(bearerValue: String) -> (insertStatus: Int, updateStatus: Int?)
    {
        let key = bearerKey
        
        let value = bearerValue
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
                kSecAttrComment as NSString : "Updated Bearer"
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
    
    /**
        Deletes the Bearer from the Device's Keychain
    
        :returns: - foundStatus: Int value of the error code returned from the keychain api when locating the bearer
                  - deleteStatus: Possible Int value of the error code returned from the keychain api when deleting the bearer
    */
    func deleteBearer() -> (foundStatus: Int, deleteStatus: Int?)
    {
        let keyToSearchFor = bearerKey
        
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
        To be used upon correct verification,
        adds or updates username in keychain access
    
        :returns: tuple of error code based on completion.
    */
    func correctLogin(username: String, password: String) -> (usernameStatus: Int, passwordStatus: Int)
    {
        var usernameStatus = errUnknown
        var passwordStatus = errUnknown
        
        let (usernameInsertStatus, usernameUpdateStatus) = insertUsername(username)
        usernameStatus = usernameInsertStatus
        if usernameStatus == Int(errSecDuplicateItem)
        {
            usernameStatus = usernameUpdateStatus!
        }
        
        let (passwordInsertStatus, passwordUpdateStatus) = insertPassword(password)
        passwordStatus = passwordInsertStatus
        if passwordStatus == Int(errSecDuplicateItem)
        {
            passwordStatus = passwordUpdateStatus!
        }
        
        return (usernameStatus, passwordStatus);
    }
    
    /**
        Checks whether or not the username and password exists in the keychain
    
        :returns: bool value
    */
    func keychainUsernameAndPasswordExist() -> Bool
    {
        var results = false
        
        let (_, usernameStatus) = retrieveUsername()
        let (_, passwordStatus) = retrievePassword()
        
        if (usernameStatus == errSecSuccess) && (passwordStatus == errSecSuccess)
        {
            results = true
        }
        
        return results
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
        
        if results == true
        {
            correctLogin(username, password: password)
        } else {
            deleteUsername()
            deletePassword()
        }
        
        return results
    }
}
