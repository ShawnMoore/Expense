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

    //MARK: View Functions
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
    
    override func viewWillAppear(animated: Bool) {
        trips = model?.tripExpenses.values.array.sorted({ $0.0.date.compare($0.1.date) == NSComparisonResult.OrderedDescending })
        tableView.reloadData()
    }
    override func viewDidDisappear(animated: Bool) {
        tableView.cellForRowAtIndexPath(lastSelected)?.accessoryType = UITableViewCellAccessoryType.None
    }
    // MARK: - Table View Functions
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section
        {
            case 0:
                return 1
            case 1:
                return (trips != nil ? trips!.count : 0)
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
            if (trips?[indexPath.row].name.isEmpty == nil) || trips![indexPath.row].name.isEmpty{
                cell?.textLabel?.text = "Trip Name is Required"
            }else{
                cell?.textLabel?.text = trips?[indexPath.row].name
            }
            
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
            oneTimeExpense?.tripId = (indexPath.section == 0 ? nil : trips![indexPath.row].id)
        }
        
    }

    //MARK: IBAction
    @IBAction func newTripCreation(sender: AnyObject) {
        performSegueWithIdentifier("toNewTrip", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toNewTrip" {
            (segue.destinationViewController as! NewTripTableViewController).oneTimeExpense = oneTimeExpense
        }
    }


}
