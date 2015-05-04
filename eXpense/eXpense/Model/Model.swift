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
    
    var removeOTE: Array<OneTimeExpense> = Array<OneTimeExpense>()
    var removeTrip: Array<TripExpense> = Array<TripExpense>()
    
    static var imageDictionary: [String: UIImage!] = ["Entertainment": UIImage(named: "EntertainmentIcon"), "Lodging": UIImage(named: "LodgingIcon"), "Meals": UIImage(named: "MealIcon"), "Other": UIImage(named: "OtherIcon3"), "Personal": UIImage(named: "PersonalIcon"), "Transportation" : UIImage(named: "TransportationIcon")]
    
    static var userId: Int = -1
    static var oneTimeIndex: Int = -1
    static var tripIndex: Int = -1
    
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var dateFormatString = "yyyy-MM-dd"
    
    private var longDateFormatter: NSDateFormatter = NSDateFormatter()
    private var longDateFormatString = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS'Z'"
    
    var bearer: String = ""
    
    override init() {
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormatString
        
        longDateFormatter = NSDateFormatter()
        longDateFormatter.dateFormat = longDateFormatString
        
        oneTimeExpenses = Array<OneTimeExpense>()
        tripExpenses = [Int: TripExpense]()
        
        removeOTE = Array<OneTimeExpense>()
        removeTrip = Array<TripExpense>()
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
                updateTrip(index)
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
    
    func updateTrip(index: Int) {
        if (self.tripExpenses.count != 0) {
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

    func refreshBearerToken(token: String) {
        bearer = token
        
        if let url = NSURL(string: "http://expense-backend.azurewebsites.net/api/account/userinfo") {
            let urlRequest = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15.0)
            urlRequest.HTTPMethod = "GET"
            
            urlRequest.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
            
            var response: NSURLResponse?
            
            var data = NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: &response, error: nil) as NSData?
            
            let html = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            var jsonError: NSError?
            
            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary {
                if let id = jsonResult["Id"] as? Int {
                    Model.userId = id
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
    
    func loadAllOnlineExpense(OneTimeURL: String, TripURL: String, completionHandler: () -> Void) {
        
        loadTripExpensesFromURLString(TripURL) {
            (object, error) -> Void in
            
            self.loadOneTimeExpensesFromURLString(OneTimeURL) {
                (object, error) -> Void in
                
                completionHandler()
            }
        }
    }
    
    func loadOneTimeExpensesFromURLString(fromURLString: String, completionHandler: (NSObject, String?) -> Void) {
        oneTimeExpenses = Array<OneTimeExpense>()
        if let url = NSURL(string: fromURLString) {
            let urlRequest = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15.0)
            urlRequest.HTTPMethod = "GET"
            urlRequest.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
            let queue = NSOperationQueue()
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue, completionHandler: {
                (response, data, error) -> Void in
                let html = NSString(data: data, encoding: NSUTF8StringEncoding)
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(self, error.localizedDescription)
                    })
                } else {
                    self.parseOneTimeExpenses(data, completionHandler: completionHandler)
                }
            })
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
                                expenseDate         = expenseData["Date"] as? String,
                                expenseCreatedDate  = expenseData["CreatedAt"] as? String,
                                expenseUserId       = expenseData["UserId"] as? Int,
                                expenseCategory     = expenseData["Category"] as? String,
                                expenseIsApproved   = expenseData["IsApproved"] as? Bool,
                                expenseIsSubmitted  = expenseData["IsSubmitted"] as? Bool{
                                    
                                    var oneTimeObject: Dictionary<String, Any> = Dictionary<String, Any>()
                                    var arrayExpenseCreatedDate = split(expenseCreatedDate) {$0 == "T"}
                                    var arrayExpenseDate = split(expenseCreatedDate) {$0 == "T"}
                                    oneTimeObject["Id"] = expenseId
                                    oneTimeObject["Name"] = expenseName
                                    oneTimeObject["Amount"] = expenseAmount
                                    oneTimeObject["Date"] = dateFormatter.dateFromString(arrayExpenseDate[0])!
                                    oneTimeObject["CreatedAt"] = dateFormatter.dateFromString(arrayExpenseCreatedDate[0])!
                                    oneTimeObject["Deleted"] = expenseDeleted
                                    oneTimeObject["UserId"] = expenseUserId
                                    oneTimeObject["Category"] = expenseCategory
                                    oneTimeObject["IsApproved"] = expenseIsApproved
                                    oneTimeObject["IsSubmitted"] = expenseIsSubmitted
                                    
                                    if let expenseLocation = expenseData["Location"] as? NSString {
                                        oneTimeObject["Location"] = expenseLocation
                                    }
                                    if let expenseDescription = expenseData["Description"] as? NSString {
                                        oneTimeObject["Description"] = expenseDescription
                                    }
                                    if let expensePhotoURI = expenseData["PhotoURI"] as? NSString {
                                        oneTimeObject["PhotoURI"] = expensePhotoURI
                                    }
                                    if let expenseLastSeen = expenseData["LastSeen"] as? String {
                                        var arrayExpenseLastSeen = split(expenseLastSeen) {$0 == "T"}
                                        oneTimeObject["LastSeen"] = dateFormatter.dateFromString(arrayExpenseLastSeen[0])!
                                    }
                                    if let expenseUpdatedAt = expenseData["UpdatedAt"] as? String {
                                        var arrayExpenseUpdatedAt = split(expenseUpdatedAt) {$0 == "T"}
                                        oneTimeObject["UpdatedAt"] = dateFormatter.dateFromString(arrayExpenseUpdatedAt[0])!
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
            }
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(self, nil)
            })
            
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
            let urlRequest = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15.0)
            urlRequest.HTTPMethod = "GET"
            urlRequest.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
            let queue = NSOperationQueue()
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue, completionHandler: {
                (response, data, error) -> Void in
                let html = NSString(data: data, encoding: NSUTF8StringEncoding)
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(self, error.localizedDescription)
                    })
                } else {
                    self.parseTripExpenses(data, completionHandler: completionHandler)
                }
            })
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
                                tripStartDate = tripData["StartDate"] as? String,
                                tripCreatedAt = tripData["CreatedAt"] as? String,
                                tripUserId = tripData["UserId"] as? Int,
                                tripIsComplete = tripData["IsComplete"] as? Bool{
                                    var arrayTripCreatedDate = split(tripCreatedAt) {$0 == "T"}
                                    var arrayTripStartDate = split(tripStartDate) {$0 == "T"}
                                    tripObject["Id"] = tripId
                                    tripObject["Name"] = tripName
                                    tripObject["StartDate"] = dateFormatter.dateFromString(arrayTripStartDate[0])!
                                    tripObject["CreatedAt"] = dateFormatter.dateFromString(arrayTripCreatedDate[0])!
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
                                    
                                    if let tripLastSeen = tripData["LastSeen"] as? String {
                                        var arrayTripLastSeen = split(tripLastSeen) {$0 == "T"}
                                        tripObject["LastSeen"] = dateFormatter.dateFromString(arrayTripLastSeen[0])
                                    }
                                    
                                    if let tripUpdatedAt = tripData["UpdatedAt"] as? String {
                                        var arrayTripUpdatedAt = split(tripUpdatedAt) {$0 == "T"}
                                        tripObject["UpdatedAt"] = dateFormatter.dateFromString(arrayTripUpdatedAt[0])
                                    }
                                    
                                    if let tripIsApproved = tripData["IsApproved"] as? Bool{
                                        tripObject["IsApproved"] = tripIsApproved
                                    }
                                    
                                    tripExpenses[tripId] = (TripExpense(dict: tripObject))
                            }

                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(self, nil)
            })
            
        } else {
            if let unwrappedError = jsonError {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(self, "\(unwrappedError)")
                })
            }
        }
    }

    func postOneTimeExpense(oneTimeExpense: OneTimeExpense, completionHandler: (id: Int?) -> Void) {
        if let url = NSURL(string: "https://expense-backend.azurewebsites.net/api/expenses/") {
            let urlRequest = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15.0)
            
            urlRequest.HTTPMethod = "POST"
            
            let body = oneTimeExpense.prettyPrint("POST", formatter: longDateFormatter).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
            urlRequest.HTTPBody = body
            
            let queue = NSOperationQueue()
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue, completionHandler: {
                (response, data, error) -> Void in
            })
            
        }
    }
    
    func putOneTimeExpense(oneTimeExpense: OneTimeExpense) {
        if let url = NSURL(string: "https://expense-backend.azurewebsites.net/api/expenses/\(oneTimeExpense.id)") {
            let urlRequest = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15.0)
            
            urlRequest.HTTPMethod = "PUT"
            
            let body = oneTimeExpense.prettyPrint("PUT", formatter: longDateFormatter).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
            urlRequest.HTTPBody = body
            
            let queue = NSOperationQueue()
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue, completionHandler: {
                (response, data, error) -> Void in
            })
            
        }
    }
    
    func deleteOneTimeExpense(oneTimeExpense: OneTimeExpense) {
        oneTimeExpense.deleted = true
        putOneTimeExpense(oneTimeExpense)
    }
    
    func submitOneTimeExpense(oneTimeExpense: OneTimeExpense) {
        oneTimeExpense.isSubmitted = true
        putOneTimeExpense(oneTimeExpense)
    }
    
    func postTripExpense(trip: TripExpense, completionHandler: (id: Int?) -> Void) {
        if let url = NSURL(string: "https://expense-backend.azurewebsites.net/api/trips/") {
            let urlRequest = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15.0)
            
            urlRequest.HTTPMethod = "POST"
            
            let body = trip.prettyPrint("POST", formatter: longDateFormatter).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
            urlRequest.HTTPBody = body
            
            let queue = NSOperationQueue()
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue, completionHandler: {
                (response, data, error) -> Void in
                
                if data.length > 0  && error == nil{
                    let html = NSString(data: data, encoding: NSUTF8StringEncoding)
                    
                    var htmlString = html as! String
                    
                    htmlString = htmlString.componentsSeparatedByString(",")[0]
                    
                    htmlString = htmlString.componentsSeparatedByString(":")[1]
                    
                    completionHandler(id: htmlString.toInt())
        
                    return
                }
                
                completionHandler(id: nil)
                return
            })
        }
    }
    
    func putTripExpense(trip: TripExpense, completionHandler: (id: Int?) -> Void) {
        if let url = NSURL(string: "https://expense-backend.azurewebsites.net/api/trips/\(trip.id)") {
            let urlRequest = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15.0)
            
            urlRequest.HTTPMethod = "PUT"
            
            let body = trip.prettyPrint("PUT", formatter: longDateFormatter).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
            urlRequest.HTTPBody = body
            
            let queue = NSOperationQueue()
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue, completionHandler: {
                (response, data, error) -> Void in
                
            })
            
        }
    }
    
    func deleteTripExpense(trip: TripExpense) {
        trip.deleted = true
        putTripExpense(trip, completionHandler: {(id) -> Void in
            
        })
    }
    
    func submitTripExpense(trip: TripExpense) {
        trip.isComplete = true
        putTripExpense(trip, completionHandler: {(id) -> Void in
            
        })
    }
    
    func refreshNetworkModel() {
        
        for (key, trip) in self.tripExpenses {
            
            self.refreshOneTimeNetworkArray(trip.oneTimeExpenses, tripId: nil)
            
            if trip.isChanged == Changed.NewTrip {
                postTripExpense(trip, completionHandler: {(id) -> Void in
                    self.refreshOneTimeNetworkArray(trip.oneTimeExpenses, tripId: id)
                })
            } else if trip.isChanged == Changed.ChangedTrip {
                putTripExpense(trip, completionHandler: {(id) -> Void in
                    self.refreshOneTimeNetworkArray(trip.oneTimeExpenses, tripId: trip.id)
                })
            }
            
            
        }
        
        refreshOneTimeNetworkArray(self.oneTimeExpenses, tripId: nil)
        
        for ote in self.removeOTE {
            deleteOneTimeExpense(ote)
        }
        
        for trip in self.removeTrip {
            deleteTripExpense(trip)
        }
    }
    
    func refreshOneTimeNetworkArray(array: [OneTimeExpense], tripId: Int?) {
        for ote in array {
            
            if tripId != nil {
                ote.tripId = tripId
            }
            
            if ote.isChanged == Changed.NewOneTime {
                postOneTimeExpense(ote, completionHandler: { (id) -> Void in
                
                })
            } else if ote.isChanged == Changed.ChangedOneTime {
                putOneTimeExpense(ote)
            }
            
        }
    }
}