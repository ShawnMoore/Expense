//
//  Model.swift
//  eXpense
//
//  Created by Shawn Moore on 2/20/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class Model: NSObject {
    var oneTimeExpenses: Array<NSObject> = Array<NSObject>()
    var tripExpenses: Array<NSObject> = Array<NSObject>()
    
    func loadOneTimeExpensesFromURLString(fromURLString: String, completionHandler: (NSObject, String?) -> Void) {
        oneTimeExpenses = Array<NSObject>()
        if let url = NSURL(string: fromURLString) {
            let urlRequest = NSMutableURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(self, error.localizedDescription)
                    })
                } else {
                    self.parseOneTimeExpenses(data, completionHandler: completionHandler)
                }
            })
            
            task.resume()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(self, "Invalid URL")
            })
        }
    }
    
    func loadOneTimeExpensesFromLocalFile(filename: String, completionHandler: (NSObject, String?) -> Void) {
        oneTimeExpenses = Array<NSObject>()
        if let filePath = NSBundle.mainBundle().pathForResource(filename, ofType: "json") {
            if let url = NSURL(fileURLWithPath: filePath) {
                let urlRequest = NSMutableURLRequest(URL: url)
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                    (data, response, error) -> Void in
                    if error != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(self, error.localizedDescription)
                        })
                    } else {
                        self.parseOneTimeExpenses(data, completionHandler: completionHandler)
                    }
                })
                
                task.resume()
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(self, "Invalid URL")
                })
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(self, "Invalid Path")
            })
        }
    }
    
    func parseOneTimeExpenses(jsonData: NSData, completionHandler: (NSObject, String?) -> Void) {
        var jsonError: NSError?
        
        var oneTimeObject: Dictionary<String, Any> = Dictionary<String, Any>()
        
        if let jsonResult = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSArray {
            if (jsonResult.count > 0) {
                for expenseData in jsonResult {
                    if let expenseName = expenseData["Name"] as? NSString {
                        if let expenseAmount = expenseData["Amount"] as? Double {
                            if let expenseDate = expenseData["Date"] as? NSString {
                                if let expenseCreatedDate = expenseData["CreatedAt"] as? NSString {
                                    if let expenseDeleted = expenseData["Deleted"] as? Bool{
                                        
                                        oneTimeObject["Name"] = expenseName
                                        oneTimeObject["Amount"] = expenseAmount
                                        oneTimeObject["Date"] = expenseDate
                                        oneTimeObject["CreatedAt"] = expenseCreatedDate
                                        oneTimeObject["Deleted"] = expenseDeleted
                                        
                                        if let expenseLocation = expenseData["Location"] as? NSString {
                                            oneTimeObject["Location"] = expenseLocation
                                        }
                                        if let expenseDescription = expenseData["Description"] as? NSString {
                                            oneTimeObject["Description"] = expenseDescription
                                        }
                                        if let expensePhotoURI = expenseData["PhotoURI"] as? NSString {
                                            oneTimeObject["PhotoURI"] = expensePhotoURI
                                        }
                                        if let expenseUserId = expenseData["UserId"] as? Int {
                                            oneTimeObject["UserId"] = expenseUserId
                                        }
                                        if let expenseTripId = expenseData["TripId"] as? Int {
                                            oneTimeObject["TripId"] = expenseTripId
                                        }
                                        if let expenseLastSeen = expenseData["LastSeen"] as? NSString {
                                            oneTimeObject["LastSeen"] = expenseLastSeen
                                        }
                                        if let expenseUpdatedAt = expenseData["UpdatedAt"] as? NSString {
                                            oneTimeObject["UpdatedAt"] = expenseUpdatedAt
                                        }
                                        
                                        oneTimeExpenses.append(OneTimeExpense(dict: oneTimeObject))
                                    }
                                }
                            }
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(self, nil)
                })
            }
            
        } else {
            if let unwrappedError = jsonError {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(self, "\(unwrappedError)")
                })
            }
        }
    }
    
    func loadTripExpensesFromURLString(fromURLString: String, completionHandler: (NSObject, String?) -> Void) {
        oneTimeExpenses = Array<NSObject>()
        if let url = NSURL(string: fromURLString) {
            let urlRequest = NSMutableURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(self, error.localizedDescription)
                    })
                } else {
                    self.parseTripExpenses(data, completionHandler: completionHandler)
                }
            })
            
            task.resume()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(self, "Invalid URL")
            })
        }
    }
    
    func loadTripExpensesFromLocalFile(filename: String, completionHandler: (NSObject, String?) -> Void) {
        oneTimeExpenses = Array<NSObject>()
        if let filePath = NSBundle.mainBundle().pathForResource(filename, ofType: "json") {
            if let url = NSURL(fileURLWithPath: filePath) {
                let urlRequest = NSMutableURLRequest(URL: url)
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                    (data, response, error) -> Void in
                    if error != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(self, error.localizedDescription)
                        })
                    } else {
                        self.parseTripExpenses(data, completionHandler: completionHandler)
                    }
                })
                
                task.resume()
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(self, "Invalid URL")
                })
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(self, "Invalid Path")
            })
        }
    }
    
    func parseTripExpenses(jsonData: NSData, completionHandler: (NSObject, String?) -> Void) {
        var jsonError: NSError?
        
        var tripObject: Dictionary<String, Any> = Dictionary<String, Any>()
        
        if let jsonResult = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSArray {
            if (jsonResult.count > 0) {
                for tripData in jsonResult {
                    if let tripId = tripData["Id"] as? NSString {
                        if let tripName = tripData["Name"] as? NSString {
                            if let tripStartDate = tripData["StartDate"] as? NSString {
                                if let tripCreatedAt = tripData["CreatedAt"] as? NSString {
                                    if let tripDeleted = tripData["Deleted"] as? Bool {
                                        if let tripUserId = tripData["UserId"] as? Int {
                                            if let tripIsComplete = tripData["IsComplete"] as? Bool {
                                                
                                                tripObject["Id"] = tripId
                                                tripObject["Name"] = tripName
                                                tripObject["StartDate"] = tripStartDate
                                                tripObject["CreatedAt"] = tripCreatedAt
                                                tripObject["Deleted"] = tripDeleted
                                                tripObject["UserId"] = tripUserId
                                                tripObject["IsComplete"] = tripIsComplete
                                                
                                                if let tripEndDate = tripData["EndDate"] as? NSString {
                                                    tripObject["EndDate"] = tripEndDate
                                                }
                                                
                                                if let tripLocation = tripData["Location"] as? NSString {
                                                    tripObject["Location"] = tripLocation
                                                }
                                                
                                                if let tripDescription = tripData["Description"] as? NSString {
                                                    tripObject["Description"] = tripDescription
                                                }
                                                
                                                if let tripLastSeen = tripData["LastSeen"] as? NSString {
                                                    tripObject["LastSeen"] = tripLastSeen
                                                }
                                                
                                                if let tripUpdatedAt = tripData["UpdatedAt"] as! NSString? {
                                                    tripObject["UpdatedAt"] = tripUpdatedAt
                                                }
                                                
                                                tripExpenses.append(TripExpense(dict: tripObject))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(self, nil)
                })
            }
            
        } else {
            if let unwrappedError = jsonError {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(self, "\(unwrappedError)")
                })
            }
        }
    }


}