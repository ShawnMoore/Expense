//
//  TripsChoiceTableViewController.swift
//  eXpense
//
//  Created by Megan Ritchey on 4/28/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class TripsChoiceTableViewController: UITableViewController {

    var model:Model?
    private var trips:[TripExpense]?
    
    var lastSelected: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    var oneTimeExpense: OneTimeExpense?
    
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var dateFormatString = "MMM dd"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        model = appDelegate.getModel()
        
        dateFormatter.dateFormat = dateFormatString
        
        trips = model?.tripExpenses.values.array.sorted({ $0.0.date.compare($0.1.date) == NSComparisonResult.OrderedDescending })
        
        if oneTimeExpense != nil {
            if oneTimeExpense?.tripId == nil {
                tableView(self.tableView, cellForRowAtIndexPath:lastSelected).accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        } else {
            tableView(self.tableView, cellForRowAtIndexPath:lastSelected).accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section
        {
            case 0:
                return 1
            case 1:
                if trips != nil {
                    return trips!.count
                }
                return 0
            default:
                return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        switch indexPath.section{
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("noneCell", forIndexPath: indexPath) as? UITableViewCell
            cell?.textLabel?.text = "None"
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("tripCell", forIndexPath: indexPath) as? UITableViewCell
            cell?.textLabel?.text = trips?[indexPath.row].name
            
            if oneTimeExpense != nil {
                if trips?[indexPath.row].id == oneTimeExpense?.tripId {
                    cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
                    lastSelected = indexPath
                }
            }
            
            if let startDate = trips?[indexPath.row].date{
                var detailString = "\(dateFormatter.stringFromDate(startDate))"
                if let endDate = trips?[indexPath.row].endDate {
                    detailString += " - \(dateFormatter.stringFromDate(endDate))"
                } else {
                    detailString += " - On Going"
                }
                cell?.detailTextLabel?.text = detailString
            }
            

        default:
            cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? UITableViewCell
            cell?.textLabel?.text = ""
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        tableView.cellForRowAtIndexPath(lastSelected)?.accessoryType = UITableViewCellAccessoryType.None
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        lastSelected = indexPath
        
        if oneTimeExpense != nil {
            if indexPath.section == 0 {
                oneTimeExpense?.tripId = nil
            } else {
                oneTimeExpense?.tripId = trips![indexPath.row].id
            }
        }
        
    }

    
    @IBAction func newTripCreation(sender: AnyObject) {
        performSegueWithIdentifier("toNewTrip", sender: self)
    }


}
