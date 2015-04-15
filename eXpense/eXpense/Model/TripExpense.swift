//
//  TripExpense.swift
//  eXpense
//
//  Created by Shawn Moore on 4/10/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class TripExpense: NSObject {
    var tripId: Int
    var name: String
    var startDate: String
    var endDate: String?
    var location: String?
    var expenseDescription: String?
    var lastSeen: String?
    var createdAt: String
    var updatedAt: String?
    var deleted: Bool
    var userId: Int
    var isComplete: Bool
    
    init(forName: String, tripId: Int, startDate: String, createdAt: String, deleted: Bool, userId: Int, isComplete: Bool)
    {
        self.tripId = tripId
        self.name = forName
        self.startDate = startDate
        self.endDate = nil
        self.location = nil
        self.expenseDescription = nil
        self.lastSeen = nil
        self.createdAt = createdAt
        self.updatedAt = nil
        self.deleted = deleted
        self.userId = userId
        self.isComplete = isComplete
    }
    
    init(forName: String, tripId: Int, startDate: String, endDate: String, location: String, description: String, lastSeen: String, createdAt: String, updatedAt: String, deleted: Bool, userId: Int, isComplete: Bool)
    {
        self.tripId = tripId
        self.name = forName
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.expenseDescription = description
        self.lastSeen = lastSeen
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deleted = deleted
        self.userId = userId
        self.isComplete = isComplete
    }
    
    init(dict: Dictionary<String, Any>)
    {
        self.tripId = dict["Id"] as! Int
        self.name = dict["Name"] as! String
        self.startDate = dict["StartDate"] as! String
        self.endDate = dict["EndDate"] as? String
        self.location = dict["Location"] as? String
        self.expenseDescription = dict["Description"] as? String
        self.lastSeen = dict["LastSeen"] as? String
        self.createdAt = dict["CreatedAt"] as! String
        self.updatedAt = dict["UpdatedAt"] as? String
        self.deleted = dict["Deleted"] as! Bool
        self.userId = dict["UserId"] as! Int
        self.isComplete = dict["IsComplete"] as! Bool
    }
}
