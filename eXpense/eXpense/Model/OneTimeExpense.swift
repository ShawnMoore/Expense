//
//  OneTimeExpense.swift
//  eXpense
//
//  Created by Shawn Moore on 4/10/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
// 

import UIKit

enum Category: String {
    case Entertainment = "Entertainment"
    case Lodging = "Lodging"
    case Meals = "Meals"
    case Other = "Other"
    case Personal = "Personal"
    case Transportation = "Transportation"
    
    static let allValues = [Entertainment, Lodging, Meals, Personal, Transportation, Other]
    
}

class OneTimeExpense: Expense {
    
    var amount: Double
    var category: Category
    var photoURI: String?
    var photoArray: NSMutableArray?
    var photoOrientation: Int?
    var tripId: Int?
    var isSubmitted: Bool
    
    init(forID: Int, name: String, amount: Double, date: NSDate, createdAt: NSDate, deleted: Bool, userId: Int, category: String, isSubmitted: Bool)
    {
        self.amount = amount
        self.category = Category(rawValue: category)!
        self.isSubmitted = isSubmitted

        super.init(forId: forID, name: name, date: date, deleted: deleted, createdAt: createdAt, userId: userId)
    }
    
    init(forID: Int, name: String, amount: Double, date: NSDate, createdAt: NSDate, deleted: Bool, location: String?, description: String?, photoURI: String?, userId: Int, tripId: Int?, lastSeen: NSDate?, updatedAt: NSDate?, category: String, isApproved: Bool?, isSubmitted: Bool)
    {
        self.amount = amount
        self.category = Category(rawValue: category)!
        self.photoURI = photoURI
        self.tripId = tripId
        self.isSubmitted = isSubmitted
        
        super.init(forId: forID, name: name, date: date, location: location, description: description, deleted: deleted, lastSeen: lastSeen, createdAt: createdAt, updatedAt: updatedAt, userId: userId, isApproved: isApproved)
    }
    
    init(dict: Dictionary<String, Any>)
    {
        self.amount = dict["Amount"] as! Double
        self.category = Category(rawValue: dict["Category"] as! String)!
        self.photoURI = dict["PhotoURI"] as? String
        self.tripId = dict["TripId"] as? Int
        self.isSubmitted = dict["IsSubmitted"] as! Bool
        
        super.init(forId: (dict["Id"] as! Int), name: (dict["Name"] as! String), date: (dict["Date"] as! NSDate), location: (dict["Location"] as? String), description: (dict["Description"] as? String), deleted: (dict["Deleted"] as! Bool), lastSeen: (dict["LastSeen"] as? NSDate), createdAt: (dict["CreatedAt"] as! NSDate), updatedAt: (dict["UpdatedAt"] as? NSDate), userId: (dict["UserId"] as! Int), isApproved: (dict["IsApproved"] as! Bool))
    }
    
    init(ote: OneTimeExpense) {
        self.amount = ote.amount
        self.category = ote.category
        self.photoURI = ote.photoURI
        self.tripId = ote.tripId
        self.isSubmitted = ote.isSubmitted
        
        super.init(forId: ote.id, name: ote.name, date: ote.date, location: ote.location, description: ote.description, deleted: ote.deleted, lastSeen: ote.lastSeen, createdAt: ote.createdAt, updatedAt: ote.updatedAt, userId: ote.userId, isApproved: ote.isApproved)
    }
    
    func prettyPrint(httpMethod: String, formatter: NSDateFormatter) -> String{
        var OTEString = "{"
        
        if httpMethod == "PUT" {
            OTEString += "\"Id\": \(self.id),"
        }
        
        OTEString += "\"Name\": \"\(self.name)\","
        OTEString += "\"Amount\": \(self.amount),"
        OTEString += "\"Date\": \"\(formatter.stringFromDate(self.date))\","
        
        if let location = self.location {
            OTEString += "\"Location\":\" \(location)\","
        }
        
        if let description = self.expenseDescription {
            OTEString += "\"Description\": \"\(description)\","
        }
        
        OTEString += "\"UserId\": \(self.userId),"
        
        if let tripId = self.tripId {
            OTEString += "\"TripId\": \"\(tripId)\","
        }
        
        if let lastSeen = self.lastSeen {
            OTEString += "\"LastSeen\": \"\(formatter.stringFromDate(lastSeen))\","
        }
        
        OTEString += "\"CreatedAt\": \"\(formatter.stringFromDate(self.createdAt))\","
        
        if let updatedAt = self.updatedAt {
            OTEString += "\"UpdateAt\": \"\(formatter.stringFromDate(updatedAt))\","
        }
        
        OTEString += "\"Deleted\": \(self.deleted),"
        
        if let isApproved = self.isApproved {
            OTEString += "\"IsApproved\": \(isApproved),"
        }
        
        OTEString += "\"Category\": \"\(self.category.rawValue)\""
        
        OTEString += "\"IsSubmitted\": \"\(self.isSubmitted)\""
        
        OTEString += "}"
        
        return OTEString

    }
}
