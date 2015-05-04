//
//  DashboardViewController.swift
//  eXpense
//
//  Created by Shawn Moore on 2/5/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    // MARK: Class Variables
    var model: Model?
    
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var dateFormatString = "MMM dd"
    
    private let prototypeCellIdentifier = "expense_cells"
    private var selectedIndex: Int?
    private var sortedArray: Array<Expense> = Array<Expense>()
    private var filteredArray: Array<Expense> = Array<Expense>()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //retrieve the model from the AppDelegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        model = appDelegate.getModel()
        
        dateFormatter.dateFormat = dateFormatString
        
        var trip = TripExpense(forName: "Test Trip", id: -1, startDate: NSDate(), createdAt: NSDate(), deleted: false, userId: 3, isComplete: false)
//        model?.putTripExpense(trip)
        model?.postTripExpense(trip, completionHandler: { id -> Void in
            println(id)
        })
//        var ote = OneTimeExpense(forID: 20, name: "MEGAN IS THE BEST IN THE WHOLE WORLD", amount: 200.00, date: NSDate(), createdAt: NSDate(), deleted: false, location: "EBN", description: "SHAWN AND DUNCAN AND REE AND BRIAN ARE PRETTY COOL AS WELL", photoURI: nil, userId: 3, tripId: nil, lastSeen: nil, updatedAt: NSDate(), category: "Other", isApproved: nil)
//        model?.putOneTimeExpense(ote)
        
//
//        model?.loadAllOnlineExpense("http://expense-backend.azurewebsites.net/api/expenses/", TripURL:"http://expense-backend.azurewebsites.net/api/trips/", completionHandler: {
//            self.sortedArray = self.sortedArray + self.model!.totalExpenses
//            
//            self.tableView.reloadData()
//            
//            if self.sortedArray.count == 0 {
//                self.tableView.tableHeaderView?.hidden = true
//            } else {
//                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
//            }
//        })
//
//        model?.loadAllLocalExpenses("oneTimeExpenses", tripFilename: "tripExpenses", completionHandler: {
//            self.sortedArray = Array<Expense>()
//            
//            self.sortedArray = self.sortedArray + self.model!.totalExpenses
//            
//            self.tableView.reloadData()
//            
//            if self.sortedArray.count == 0 {
//                self.tableView.tableHeaderView?.hidden = true
//            } else {
//                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
//            }
//        })

    

        //Get the Navigation Bar from the Navigation Controller
        let navBar = self.navigationController!.navigationBar
        
        //Set the title attributes for the Navigation Bar
        let titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "GujaratiSangamMN", size: 20)!
        ]
        
        //Set Navigation Bar properties from the Navigation Controller's Navigation bar
        navBar.translucent = false
        navBar.barStyle = UIBarStyle.Black
        navBar.barTintColor = UIColor(red: 37/255, green: 178/255, blue: 74/255, alpha: 1)
        navBar.titleTextAttributes = titleTextAttributes
        navBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.navigationController?.toolbar.translucent = false
        self.navigationController?.toolbar.barTintColor = UIColor(red: 37/255, green: 178/255, blue: 74/255, alpha: 1)
        self.navigationController?.toolbar.tintColor = UIColor.whiteColor()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        model?.updateModel()
        sortedArray = Array<Expense>() + model!.totalExpenses
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return filteredArray.count
        } else {
            return sortedArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(prototypeCellIdentifier) as! DashboardTableViewCell
        
        var dataExpense: Expense!
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            dataExpense = self.filteredArray[indexPath.row]
        } else {
            dataExpense = self.sortedArray[indexPath.row]
        }

        cell.cellImage.contentMode = UIViewContentMode.Center
        
        if dataExpense.name.isEmpty {
            cell.titleLabel.text = "No Purpose Given - ID: \(dataExpense.id)"
        } else {
            cell.titleLabel.text = "\(dataExpense.name) - ID: \(dataExpense.id)"
        }
        
        var detailString = dateFormatter.stringFromDate(dataExpense.date)
        
        if( dataExpense is TripExpense ) {
            cell.cellImage.image = UIImage(named: "TripIcon")
            
            if let endDate = (dataExpense as! TripExpense).endDate {
                detailString += " - \(dateFormatter.stringFromDate(endDate))"
            } else {
                detailString += " - On Going"
            }
            
        } else if( dataExpense is OneTimeExpense ) {
            
            let oneTimeData: OneTimeExpense = dataExpense as! OneTimeExpense
            
            switch oneTimeData.category {
            case Category.Entertainment:
                cell.cellImage.image = Model.imageDictionary["Entertainment"]
            case Category.Lodging:
                cell.cellImage.image = Model.imageDictionary["Lodging"]
            case Category.Meals:
                cell.cellImage.image = Model.imageDictionary["Meals"]
            case Category.Personal:
                cell.cellImage.image = Model.imageDictionary["Personal"]
            case Category.Transportation:
                cell.cellImage.image = Model.imageDictionary["Transportation"]
            default:
                cell.cellImage.image = Model.imageDictionary["Other"]
            }
            
            if let location = oneTimeData.location {
                if count(location) != 0 {
                    detailString += " | \(location)"
                }
            }
            
        }
        
        cell.detailLabel.text = "\(detailString)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedIndex = indexPath.row
        
        if self.sortedArray[indexPath.row] is OneTimeExpense {
            performSegueWithIdentifier("showExpense", sender: self)
        } else if self.sortedArray[indexPath.row] is TripExpense {
            performSegueWithIdentifier("showTripDetail", sender: self)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            sortedArray[indexPath.row].deleted = true
            
            if sortedArray[indexPath.row] is TripExpense {
                if sortedArray[indexPath.row].isChanged != Changed.NewTrip {
                    model?.removeTrip.append(sortedArray[indexPath.row].id)
                }
                
                var OTEList = model?.tripExpenses[sortedArray[indexPath.row].id]?.oneTimeExpenses
                for oneTime in OTEList!{
                    oneTime.deleted = true
                    
                    if oneTime.isChanged != Changed.NewOneTime {
                        model?.removeOTE.append(oneTime.id)
                    }
                }
            } else if sortedArray[indexPath.row] is OneTimeExpense {
                if sortedArray[indexPath.row].isChanged != Changed.NewOneTime {
                    model?.removeOTE.append(sortedArray[indexPath.row].id)
                }
            }
            sortedArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    @IBAction func addNewExpense(sender: AnyObject) {
        
        selectedIndex = nil
        performSegueWithIdentifier("showExpense", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTripDetail" {
            (segue.destinationViewController as! TripsViewController).tripData = sortedArray[selectedIndex!] as? TripExpense
        } else if segue.identifier == "showExpense" {
            if let index = selectedIndex {
                (segue.destinationViewController as! NewOneTimeTableViewController).newExpense = false
                (segue.destinationViewController as! NewOneTimeTableViewController).oneTime = sortedArray[selectedIndex!] as? OneTimeExpense
            } else {
                (segue.destinationViewController as! NewOneTimeTableViewController).newExpense = true
            }
        }
    }
    
    func filterContentArray(searchString: String, categoryFilter: String = "Date") {
        self.filteredArray = sortedArray.filter({ (expense: Expense) -> Bool in
            if categoryFilter == "Date" {
                var stringMatch = self.dateFormatter.stringFromDate(expense.date).rangeOfString(searchString)
                
                if stringMatch == nil && expense is TripExpense {
                    
                    if let endDate = (expense as! TripExpense).endDate {
                        stringMatch = self.dateFormatter.stringFromDate(endDate).rangeOfString(searchString)
                    }
                }
                
                return (stringMatch != nil)
            }
            
            return false
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        filterContentArray(searchString, categoryFilter: "Date")
        return true;
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        filterContentArray(controller.searchBar.text, categoryFilter: "Date")
        return true;
    }
}
