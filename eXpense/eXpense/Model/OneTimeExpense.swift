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
}

class OneTimeExpense: Expense {
    
    var amount: Double
    var category: Category
    var photoURI: String?
    var tripId: Int?
    
    init(forID: Int, name: String, amount: Double, date: NSDate, createdAt: NSDate, deleted: Bool, userId: Int, category: String)
    {
        self.amount = amount
        self.category = Category(rawValue: category)!
        super.init(forId: forID, name: name, date: date, deleted: deleted, createdAt: createdAt, userId: userId)
    }
    
    init(forID: Int, name: String, amount: Double, date: NSDate, createdAt: NSDate, deleted: Bool, location: String?, description: String?, photoURI: String?, userId: Int, tripId: Int?, lastSeen: NSDate?, updatedAt: NSDate?, category: String)
    {
        self.amount = amount
        self.category = Category(rawValue: category)!
        self.photoURI = photoURI
        self.tripId = tripId
        super.init(forId: forID, name: name, date: date, location: location, description: description, deleted: deleted, lastSeen: lastSeen, createdAt: createdAt, updatedAt: updatedAt, userId: userId)
    }
    
    init(dict: Dictionary<String, Any>)
    {
        self.amount = dict["Amount"] as! Double
        self.category = Category(rawValue: dict["Category"] as! String)!
        self.photoURI = dict["PhotoURI"] as? String
        self.tripId = dict["TripId"] as? Int
        
        super.init(forId: (dict["Id"] as! Int), name: (dict["Name"] as! String), date: (dict["Date"] as! NSDate), location: (dict["Location"] as? String), description: (dict["Description"] as? String), deleted: (dict["Deleted"] as! Bool), lastSeen: (dict["LastSeen"] as? NSDate), createdAt: (dict["CreatedAt"] as! NSDate), updatedAt: (dict["UpdatedAt"] as? NSDate), userId: (dict["UserId"] as! Int))
    }
}
