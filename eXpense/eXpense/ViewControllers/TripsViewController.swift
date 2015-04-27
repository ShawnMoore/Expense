//
//  TripsViewController.swift
//  eXpense
//
//  Created by Shawn Moore on 2/5/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class TripsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var model: Model?
    var tripIndex: Int?
    
    private let prototypeCellIdentifier = "expense_cells"
    private var tripData: TripExpense?
    
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var dateFormatString = "MMM dd"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        model = appDelegate.getModel()
        
        dateFormatter.dateFormat = dateFormatString
        
        if let index = tripIndex {
            tripData = (model!.totalExpenses[index] as! TripExpense)
            
            self.navigationItem.title = tripData?.name
        }
        
        
        
//        self.navigationController!.navigationBar.translucent = false
//        self.navigationController!.navigationBar.barTintColor = UIColor(red: 37/255, green: 178/255, blue: 74/255, alpha: 1)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripData!.oneTimeExpenses.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(prototypeCellIdentifier) as! DashboardTableViewCell
        let oneTimeExpense = tripData!.oneTimeExpenses[indexPath.row]
        
        cell.cellImage.contentMode = UIViewContentMode.Center
        
        cell.titleLabel.text = "\(oneTimeExpense.name) - ID: \(oneTimeExpense.id)"
        
        var detailString = dateFormatter.stringFromDate(oneTimeExpense.date)
        
        switch oneTimeExpense.category {
        case Category.Entertainment:
            cell.cellImage.image = UIImage(named: "EntertainmentIcon")
        case Category.Lodging:
            cell.cellImage.image = UIImage(named: "LodgingIcon")
        case Category.Meals:
            cell.cellImage.image = UIImage(named: "MealIcon")
        case Category.Personal:
            cell.cellImage.image = UIImage(named: "PersonalIcon")
        case Category.Transportation:
            cell.cellImage.image = UIImage(named: "TransportationIcon")
        default:
            cell.cellImage.image = UIImage(named: "OtherIcon3")
        }
        
        if let location = oneTimeExpense.location {
            detailString += " | \(location)"
        }
        
        cell.detailLabel.text = "\(detailString)"
        
        return cell
    }
    
    @IBAction func addNewExpense(sender: AnyObject) {
        performSegueWithIdentifier("showExpense", sender: self)
    }

}
