//
//  Model.swift
//  eXpense
//
//  Created by Shawn Moore on 2/20/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class Model: NSObject {
    var totalExpenses: Array<Expense> {
        get {
            var array: Array<Expense> = Array<Expense>()
            
            updateModel()
            
            array = array + self.oneTimeExpenses
            array = array + self.tripExpenses.values.array
            
            return sorted(array) { $0.0.date.compare($0.1.date) == NSComparisonResult.OrderedDescending }
        }
    }
    
    var oneTimeExpenses: Array<OneTimeExpense> = Array<OneTimeExpense>()
    var tripExpenses: [Int: TripExpense] = [Int: TripExpense]()
    
    static var imageDictionary: [String: UIImage!] = ["Entertainment": UIImage(named: "EntertainmentIcon"), "Lodging": UIImage(named: "LodgingIcon"), "Meals": UIImage(named: "MealIcon"), "Other": UIImage(named: "OtherIcon3"), "Personal": UIImage(named: "PersonalIcon"), "Transportation" : UIImage(named: "TransportationIcon")]
    
    static var userId: Int = -1
    static var oneTimeIndex: Int = -1
    static var tripIndex: Int = -1
    
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var dateFormatString = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSzzzzz"
    
    override init() {
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormatString
        
        Model.userId = 1
    }
    
    func updateModel() {
        var removeArray = Array<Int>()
        
        if (self.oneTimeExpenses.count != 0) {
            
            for index in 0...(self.oneTimeExpenses.count-1) {
                if self.oneTimeExpenses[index].tripId != nil {
                    removeArray.append(index)
                }
            }
        }
        
        removeArray.sort({ $0 > $1 })
        
        for index in removeArray {
            let value = self.oneTimeExpenses[index]
            self.oneTimeExpenses.removeAtIndex(index)
            
            if let trip = self.tripExpenses[value.tripId!] {
                trip.oneTimeExpenses.append(value)
            } else {
                oneTimeExpenses.append(value)
            }
        }
        
        removeArray = Array<Int>()
        
        if (self.oneTimeExpenses.count != 0) {
            
            for index in 0...(self.oneTimeExpenses.count-1) {
                if self.oneTimeExpenses[index].deleted == true {
                    removeArray.append(index)
                }
            }
        }
        
        removeArray.sort({ $0 > $1 })
        
        for index in removeArray {
            self.oneTimeExpenses.removeAtIndex(index)
        }
        
        if (self.tripExpenses.count != 0) {
            
            for index in self.tripExpenses.keys.array {
                
                if (self.tripExpenses[index] != nil) {
                    
                    if(self.tripExpenses[index]!.oneTimeExpenses.count != 0) {
                        let id = self.tripExpenses[index]!.id
                        
                        var self_index = 0
                        
                        //If your reading this, I am so so sorry....We dont know why this works....just dont touch it
                        //For god sakes....DONT TOUCH IT
                        for ote in self.tripExpenses[index]!.oneTimeExpenses {
                            if self.tripExpenses[index]!.oneTimeExpenses[self_index].deleted == true {
                                 self.tripExpenses[index]!.oneTimeExpenses.removeAtIndex(self_index)
                            } else {
                                if (self.tripExpenses[index]!.oneTimeExpenses[self_index].tripId != id) {
                                    let value = self.tripExpenses[index]!.oneTimeExpenses[self_index]

                                    self.tripExpenses[index]!.oneTimeExpenses.removeAtIndex(self_index)

                                    if (value.tripId == nil) {
                                        self.oneTimeExpenses.append(value)
                                    } else {
                                        self.tripExpenses[value.tripId!]?.oneTimeExpenses.append(value)
                                    }
                                } else {
                                    self_index++
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if (self.tripExpenses.count != 0) {
            for index in self.tripExpenses.keys.array {
                if self.tripExpenses[index]!.deleted == true {
                    self.tripExpenses[index] = nil
                }
            }
        }
    }
    
    func loadAllLocalExpenses(oneTimeFilename: String, tripFilename: String, completionHandler: () -> Void) {

            loadTripExpensesFromLocalFile(tripFilename) {
                (object, error) -> Void in
                
                    self.loadOneTimeExpensesFromLocalFile(oneTimeFilename) {
                        (object, error) -> Void in
                        
                            completionHandler()
                    }
            }
    }
    
    func loadOneTimeExpensesFromURLString(fromURLString: String, completionHandler: (NSObject, String?) -> Void) {
        oneTimeExpenses = Array<OneTimeExpense>()
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
        oneTimeExpenses = Array<OneTimeExpense>()
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
    
        if let jsonResult = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSArray {
            if (jsonResult.count > 0) {
                for expenseData in jsonResult {
                    if let expenseDeleted = expenseData["Deleted"] as? Bool{
                        if expenseDeleted == false{
                            if let expenseId           = expenseData["Id"] as? Int,
                                expenseName         = expenseData["Name"] as? NSString,
                                expenseAmount       = expenseData["Amount"] as? Double,
                                expenseDate         = expenseData["Date"] as? NSString,
                                expenseCreatedDate  = expenseData["CreatedAt"] as? NSString,
                                expenseUserId       = expenseData["UserId"] as? Int,
                                expenseCategory     = expenseData["Category"] as? String{
                                    
                                    var oneTimeObject: Dictionary<String, Any> = Dictionary<String, Any>()
                                    
                                    oneTimeObject["Id"] = expenseId
                                    oneTimeObject["Name"] = expenseName
                                    oneTimeObject["Amount"] = expenseAmount
                                    oneTimeObject["Date"] = dateFormatter.dateFromString(expenseDate as String)!
                                    oneTimeObject["CreatedAt"] = dateFormatter.dateFromString(expenseCreatedDate as String)!
                                    oneTimeObject["Deleted"] = expenseDeleted
                                    oneTimeObject["UserId"] = expenseUserId
                                    oneTimeObject["Category"] = expenseCategory
                                    
                                    if let expenseLocation = expenseData["Location"] as? NSString {
                                        oneTimeObject["Location"] = expenseLocation
                                    }
                                    if let expenseDescription = expenseData["Description"] as? NSString {
                                        oneTimeObject["Description"] = expenseDescription
                                    }
                                    if let expensePhotoURI = expenseData["PhotoURI"] as? NSString {
                                        oneTimeObject["PhotoURI"] = expensePhotoURI
                                    }
                                    if let expenseLastSeen = expenseData["LastSeen"] as? NSString {
                                        oneTimeObject["LastSeen"] = dateFormatter.dateFromString(expenseLastSeen as String)!
                                    }
                                    if let expenseUpdatedAt = expenseData["UpdatedAt"] as? NSString {
                                        oneTimeObject["UpdatedAt"] = dateFormatter.dateFromString(expenseUpdatedAt as String)!
                                    }
                                    
                                    if let expenseTripId = expenseData["TripId"] as? Int {
                                        oneTimeObject["TripId"] = expenseTripId
                                        
                                        if let trip = tripExpenses[expenseTripId] {
                                            trip.oneTimeExpenses.append(OneTimeExpense(dict: oneTimeObject))
                                        } else {
                                            oneTimeExpenses.append(OneTimeExpense(dict: oneTimeObject))
                                        }
                                        
                                    } else {
                                        oneTimeExpenses.append(OneTimeExpense(dict: oneTimeObject))
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
        tripExpenses = [Int: TripExpense]()
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
        tripExpenses = [Int: TripExpense]()
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
                    if let tripDeleted = tripData["Deleted"] as? Bool {
                        if tripDeleted == false{
                            if let tripId = tripData["Id"] as? Int,
                                tripName = tripData["Name"] as? NSString,
                                tripStartDate = tripData["StartDate"] as? NSString,
                                tripCreatedAt = tripData["CreatedAt"] as? NSString,
                                tripUserId = tripData["UserId"] as? Int,
                                tripIsComplete = tripData["IsComplete"] as? Bool {
                                    
                                    tripObject["Id"] = tripId
                                    tripObject["Name"] = tripName
                                    tripObject["StartDate"] = dateFormatter.dateFromString(tripStartDate as String)!
                                    tripObject["CreatedAt"] = dateFormatter.dateFromString(tripCreatedAt as String)!
                                    tripObject["Deleted"] = tripDeleted
                                    tripObject["UserId"] = tripUserId
                                    tripObject["IsComplete"] = tripIsComplete
                                    
                                    if let tripEndDate = tripData["EndDate"] as? NSString {
                                        tripObject["EndDate"] = dateFormatter.dateFromString(tripEndDate as String)
                                    }
                                    
                                    if let tripLocation = tripData["Location"] as? NSString {
                                        tripObject["Location"] = tripLocation
                                    }
                                    
                                    if let tripDescription = tripData["Description"] as? NSString {
                                        tripObject["Description"] = tripDescription
                                    }
                                    
                                    if let tripLastSeen = tripData["LastSeen"] as? NSString {
                                        tripObject["LastSeen"] = dateFormatter.dateFromString(tripLastSeen as String)
                                    }
                                    
                                    if let tripUpdatedAt = tripData["UpdatedAt"] as? NSString {
                                        tripObject["UpdatedAt"] = dateFormatter.dateFromString(tripUpdatedAt as String)
                                    }
                                    
                                    tripExpenses[tripId] = (TripExpense(dict: tripObject))
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