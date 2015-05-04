//
//  TripExpense.swift
//  eXpense
//
//  Created by Shawn Moore on 4/10/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class TripExpense: Expense {
    var endDate: NSDate?
    var isComplete: Bool
    var oneTimeExpenses: [OneTimeExpense] = [OneTimeExpense]()
    
    init(forName: String, id: Int, startDate: NSDate, createdAt: NSDate, deleted: Bool, userId: Int, isComplete: Bool)
    {
        self.endDate = nil
        self.isComplete = isComplete
        super.init(forId: id, name: forName, date: startDate, deleted: deleted, createdAt: createdAt, userId: userId)
    }
    
    init(forName: String, id: Int, startDate: NSDate, endDate: NSDate?, location: String?, description: String?, lastSeen: NSDate?, createdAt: NSDate, updatedAt: NSDate?, deleted: Bool, userId: Int, isComplete: Bool, isApproved: Bool?)
    {
        self.endDate = endDate
        self.isComplete = isComplete
        
        super.init(forId: id, name: forName, date: startDate, location: location, description: description, deleted: deleted, lastSeen: lastSeen, createdAt: createdAt, updatedAt: updatedAt, userId: userId, isApproved: isApproved)
    }
    
    init(dict: Dictionary<String, Any>)
    {
        self.endDate = dict["EndDate"] as? NSDate
        self.isComplete = dict["IsComplete"] as! Bool
        
        super.init(forId: (dict["Id"] as! Int), name: (dict["Name"] as! String), date: (dict["StartDate"] as! NSDate), location: (dict["Location"] as? String), description: (dict["Description"] as? String), deleted: (dict["Deleted"] as! Bool), lastSeen: (dict["LastSeen"] as? NSDate), createdAt: (dict["CreatedAt"] as! NSDate), updatedAt: (dict["UpdatedAt"] as? NSDate), userId: (dict["UserId"] as! Int), isApproved: (dict["IsApproved"] as? Bool))
    }
    
    init(trip: TripExpense)
    {
        self.endDate = trip.endDate
        self.isComplete = trip.isComplete
        
        super.init(forId: trip.id, name: trip.name, date: trip.date, location: trip.location, description: trip.expenseDescription, deleted: trip.deleted, lastSeen: trip.lastSeen, createdAt: trip.createdAt, updatedAt: trip.updatedAt, userId: trip.userId, isApproved: trip.isApproved)
    }
    
    func prettyPrint(httpMethod: String, formatter: NSDateFormatter) -> String{
        var tripString = "{"
        
        if httpMethod == "PUT" {
            tripString += "\"Id\": \(self.id),"
        }
        
        tripString += "\"Name\": \"\(self.name)\","
        tripString += "\"StartDate\": \"\(formatter.stringFromDate(self.date))\","
        
        if let endDate = self.endDate {
            tripString += "\"EndDate\": \"\(formatter.stringFromDate(endDate))\","
        }
        
        if let location = self.location {
            tripString += "\"Location\":\" \(location)\","
        }
        
        if let description = self.expenseDescription {
            tripString += "\"Description\": \"\(description)\","
        }
        
        tripString += "\"UserId\": \(self.userId),"
        
        if let lastSeen = self.lastSeen {
            tripString += "\"LastSeen\": \"\(formatter.stringFromDate(lastSeen))\","
        }
        
        tripString += "\"CreatedAt\": \"\(formatter.stringFromDate(self.createdAt))\","
        
        if let updatedAt = self.updatedAt {
            tripString += "\"UpdateAt\": \"\(formatter.stringFromDate(updatedAt))\","
        }
        
        tripString += "\"Deleted\": \(self.deleted),"
        
        tripString += "\"IsComplete\": \(self.isComplete)"
        
        tripString += "}"
        
        return tripString
        
    }
}
