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
        
        self.navigationItem.title = tripData!.name
        displayTripInfo()
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
        return oneTimeExpenses!.count
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
    //MARK: Deleting Functions
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            oneTimeExpenses?[indexPath.row].deleted = true
            oneTimeExpenses?.removeAtIndex(indexPath.row)
            model?.updateModel()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    //MARK: IBAction Functinos
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
    
    @IBAction func submit(sender: AnyObject) {
        if tripSubmissionCheck(){
            oneTimeExpensesSubmissionCheck()
        }
    }
    //MARK: Submission Functions
    func tripSubmissionCheck()-> Bool{
        var nameString = tripData?.name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var locationString = tripData?.location?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if let nameIsEmpty = nameString?.isEmpty,
            locationIsEmpty = locationString?.isEmpty{
                if(!nameIsEmpty && !locationIsEmpty && tripData?.endDate != nil){
                    return true
                }
        }
        var alert = UIAlertView(title: "Invalid Trip Submission", message: "Please make sure you have entered in a trip name, location, and end date.", delegate: self, cancelButtonTitle: "Okay")
        alert.show()
        return false
    }
    
    func oneTimeExpensesSubmissionCheck() -> Bool{
        var i = 0;
        var alertMessage = ""
        for expense in oneTimeExpenses!{
            var nameString = expense.name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            var locationString = expense.location?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if count(nameString) == 0{
                alertMessage = "Please make sure you have entered in a purpose."
            }else if (locationString?.isEmpty == nil) || locationString!.isEmpty {
                alertMessage = "Please make sure you have entered in a location."
            }else if expense.amount <= 0.00 {
                alertMessage = "Please make sure you have entered in an amount."
            }
            i++
            if alertMessage != "" {
                var alert = UIAlertView(title: "Row \(i): Invalid Expense", message: alertMessage, delegate: self, cancelButtonTitle: "Okay")
                alert.show()
                return false
            }
        }
        return true
    }
}
