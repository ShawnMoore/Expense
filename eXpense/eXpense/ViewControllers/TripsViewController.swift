//
//  TripsViewController.swift
//  eXpense
//
//  Created by Shawn Moore on 2/5/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class TripsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var model: Model?
    var tripData: TripExpense?
    
    private var oneTimeExpenses: Array<OneTimeExpense>?
    private let prototypeCellIdentifier = "expense_cells"
    private var selectedIndex: Int?
    
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var dateFormatString = "MMM dd"
    
    //MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        model = appDelegate.getModel()
        
        dateFormatter.dateFormat = dateFormatString
        
        self.navigationItem.title = tripData!.name
        displayTripInfo()
        
        oneTimeExpenses = Array<OneTimeExpense>() + tripData!.oneTimeExpenses
        oneTimeExpenses?.sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
    }
    
    override func viewWillAppear(animated: Bool) {
        model?.updateModel()
        oneTimeExpenses = Array<OneTimeExpense>() + tripData!.oneTimeExpenses
        oneTimeExpenses?.sort({ $0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
        tableView.reloadData()
        
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    //MARK: Table View Functions
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
        let oneTimeExpense = oneTimeExpenses![indexPath.row]
        cell.cellImage.contentMode = UIViewContentMode.Center
        
        if oneTimeExpense.name.isEmpty {
            cell.titleLabel.text = "No Purpose Given - ID: \(oneTimeExpense.id)"
        } else {
            cell.titleLabel.text = "\(oneTimeExpense.name) - ID: \(oneTimeExpense.id)"
        }
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        performSegueWithIdentifier("showExpense", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    //IBAction Functinos
    @IBAction func addNewExpense(sender: AnyObject) {
        selectedIndex = nil
        performSegueWithIdentifier("showExpense", sender: self)
    }
    
    @IBAction func editExistingTrip(sender: AnyObject) {
        performSegueWithIdentifier("editExistingTrip", sender: self)
    }
    
    //MARK: Prepare For Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showExpense" {
            if selectedIndex == nil{
                (segue.destinationViewController as! NewOneTimeTableViewController).newExpense = true
                (segue.destinationViewController as! NewOneTimeTableViewController).newExpenseTripId = tripData?.id
            }
            else{
                (segue.destinationViewController as! NewOneTimeTableViewController).newExpense = false
                (segue.destinationViewController as! NewOneTimeTableViewController).oneTime = oneTimeExpenses![selectedIndex!]
            }
        } else if segue.identifier == "editExistingTrip" {
            (segue.destinationViewController as! NewTripTableViewController).newTrip = false
            (segue.destinationViewController as! NewTripTableViewController).trip = tripData
        }
    }
    
    //MARK: Utility Functions
    func displayTripInfo(){
        if let location = tripData?.location{
            locationLabel.text = "Location: \(location)"
        }
        if let description = tripData?.expenseDescription{
            descriptionLabel.text = "Description: \(description)"
        }
        if let startDate = tripData?.date{
            var dateString = "Date: \(dateFormatter.stringFromDate(startDate))"
            if let endDate = tripData?.endDate {
                dateString += " - \(dateFormatter.stringFromDate(endDate))"
            } else {
                dateString += " - On Going"
            }
            dateLabel?.text = dateString
        }
        
    }

}
