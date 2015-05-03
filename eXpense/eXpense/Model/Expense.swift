//
//  Expense.swift
//  eXpense
//
//  Created by Shawn Moore on 4/16/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class Expense: NSObject {
    
    var id: Int
    var name: String
    var date: NSDate              //startDate for TRIPS, date for ONE TIME
    var location: String?
    var expenseDescription: String?
    var deleted: Bool
    var lastSeen: NSDate?
    var createdAt: NSDate
    var updatedAt: NSDate?
    var userId: Int
    var isApproved: Bool?
    
    init(forId: Int, name: String, date: NSDate, deleted: Bool, createdAt: NSDate, userId: Int) {
        self.id = forId
        self.name = name
        self.date = date
        self.location = nil
        self.expenseDescription = nil
        self.deleted = deleted
        self.lastSeen = nil
        self.createdAt = createdAt
        self.updatedAt = nil
        self.userId = userId
        self.isApproved = nil
    }
    
    init(forId: Int, name: String, date: NSDate, location: String?, description: String?, deleted: Bool, lastSeen: NSDate?, createdAt: NSDate, updatedAt: NSDate?, userId: Int, isApproved: Bool?) {
        self.id = forId
        self.name = name
        self.date = date
        self.location = location
        self.expenseDescription = description
        self.deleted = deleted
        self.lastSeen = lastSeen
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.userId = userId
        self.isApproved = isApproved
    }
    
    init(expense: Expense) {
        self.id = expense.id
        self.name = expense.name
        self.date = expense.date
        self.location = expense.location
        self.expenseDescription = expense.expenseDescription
        self.deleted = expense.deleted
        self.lastSeen = expense.lastSeen
        self.createdAt = expense.createdAt
        self.updatedAt = expense.updatedAt
        self.userId = expense.userId
        self.isApproved = expense.isApproved
    }
    
}
