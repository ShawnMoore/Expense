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
    var trips:[TripExpense]?
    var lastSelected: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var dateFormatString = "MMM dd"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        model = appDelegate.getModel()
        
        dateFormatter.dateFormat = dateFormatString
        
        trips = model?.tripExpenses.values.array.sorted({ $0.0.date.compare($0.1.date) == NSComparisonResult.OrderedDescending })
        
        tableView(self.tableView, cellForRowAtIndexPath:lastSelected).accessoryType = UITableViewCellAccessoryType.Checkmark
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
