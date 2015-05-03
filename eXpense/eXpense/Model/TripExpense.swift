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
    
    init(forName: String, id: Int, startDate: NSDate, createdAt: NSDate, deleted: Bool, userId: Int, isComplete: Bool, isApproved: Bool)
    {
        self.endDate = nil
        self.isComplete = isComplete
        super.init(forId: id, name: forName, date: startDate, deleted: deleted, createdAt: createdAt, userId: userId, isApproved: isApproved)
    }
    
    init(forName: String, id: Int, startDate: NSDate, endDate: NSDate?, location: String?, description: String?, lastSeen: NSDate?, createdAt: NSDate, updatedAt: NSDate?, deleted: Bool, userId: Int, isComplete: Bool, isApproved: Bool)
    {
        self.endDate = endDate
        self.isComplete = isComplete
        
        super.init(forId: id, name: forName, date: startDate, location: location, description: description, deleted: deleted, lastSeen: lastSeen, createdAt: createdAt, updatedAt: updatedAt, userId: userId, isApproved: isApproved)
    }
    
    init(dict: Dictionary<String, Any>)
    {
        self.endDate = dict["EndDate"] as? NSDate
        self.isComplete = dict["IsComplete"] as! Bool
        
        super.init(forId: (dict["Id"] as! Int), name: (dict["Name"] as! String), date: (dict["StartDate"] as! NSDate), location: (dict["Location"] as? String), description: (dict["Description"] as? String), deleted: (dict["Deleted"] as! Bool), lastSeen: (dict["LastSeen"] as? NSDate), createdAt: (dict["CreatedAt"] as! NSDate), updatedAt: (dict["UpdatedAt"] as? NSDate), userId: (dict["UserId"] as! Int), isApproved: (dict["IsApproved"] as! Bool))
    }
}
