//
//  OneTimeExpense.swift
//  eXpense
//
//  Created by Shawn Moore on 4/10/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//
//  \SAMPLE JSON OUTPUT
//  "Id": 1,
//  "Name": "sample string 2",
//  "Amount": 3.1,
//  "Date": "2015-04-03T02:14:46.6757124+00:00",
//  "Location": "sample string 5",
//  "Description": "sample string 6",
//  "PhotoURI": "sample string 7",
//  "UserId": 8,
//  "TripId": 1,
//  "LastSeen": "2015-04-03T02:14:46.6913299+00:00",
//  "CreatedAt": "2015-04-03T02:14:46.6913299+00:00",
//  "UpdatedAt": "2015-04-03T02:14:46.6913299+00:00",
//  "Deleted": true

import UIKit

class OneTimeExpense: NSObject {
    var id: Int
    var name: String
    var amount: Double
    var date: String
    var location: String?
    var expenseDescription: String?
    var photoURI: String?
    var userId: Int?
    var tripId: Int?
    var lastSeen: String?
    var createdAt: String
    var updatedAt: String?
    var deleted: Bool
    
    init(forID: Int, name: String, amount: Double, date: String, createdAt: String, deleted: Bool)
    {
        self.id = forID
        self.name = name
        self.amount = amount
        self.date = date
        self.location = nil
        self.expenseDescription = nil
        self.photoURI = nil
        self.userId = nil
        self.tripId = nil
        self.lastSeen = nil
        self.createdAt = createdAt
        self.updatedAt = nil
        self.deleted = deleted
    }
    
    init(forID: Int, name: String, amount: Double, date: String, createdAt: String, deleted: Bool, location: String, description: String, photoURI: String, userId: Int, tripId: Int, lastSeen: String, updatedAt: String)
    {
        self.id = forID
        self.name = name
        self.amount = amount
        self.date = date
        self.location = location
        self.expenseDescription = description
        self.photoURI = photoURI
        self.userId = userId
        self.tripId = tripId
        self.lastSeen = lastSeen
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deleted = deleted
    }
    
    init(dict: Dictionary<String, Any>)
    {
        self.id = dict["Id"] as! Int
        self.name = dict["Name"] as! String
        self.amount = dict["Amount"] as! Double
        self.date = dict["Date"] as! String
        self.location = dict["Location"] as? String
        self.expenseDescription = dict["Description"] as? String
        self.photoURI = dict["PhotoURI"] as? String
        self.userId = dict["UserId"] as? Int
        self.tripId = dict["TripId"] as? Int
        self.lastSeen = dict["LastSeen"] as? String
        self.createdAt = dict["CreatedAt"] as! String
        self.updatedAt = dict["UpdatedAt"] as? String
        self.deleted = dict["Deleted"] as! Bool
    }
}
