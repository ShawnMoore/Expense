//
//  DashboardViewController.swift
//  eXpense
//
//  Created by Shawn Moore on 2/5/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Class Variables
    var model: Model?
    
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var dateFormatString = "MMM dd"
    
    private let prototypeCellIdentifier = "expense_cells"
    private var selectedIndex: Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //retrieve the model from the AppDelegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        model = appDelegate.getModel()
        
        dateFormatter.dateFormat = dateFormatString

//        model?.loadOneTimeExpensesFromURLString("http://dalemusser.com/test/json/test.json") {
//            (object, error) -> Void in
//            println("Success")
//        }
        
        model?.loadAllLocalExpenses("oneTimeExpenses", tripFilename: "tripExpenses", completionHandler: {
            self.tableView.reloadData()
        })
        
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
        return model!.totalExpenses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(prototypeCellIdentifier) as! DashboardTableViewCell
        let dataExpense = model!.totalExpenses[indexPath.row]

        cell.cellImage.contentMode = UIViewContentMode.Center
        
        cell.titleLabel.text = "\(dataExpense.name) - ID: \(dataExpense.id)"
        
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
            
            if let location = oneTimeData.location {
                detailString += " | \(location)"
            }
            
        }
        
        
        cell.detailLabel.text = "\(detailString)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        if model!.totalExpenses[indexPath.row] is OneTimeExpense {
            
            performSegueWithIdentifier("showExpense", sender: self)
            
        } else if model!.totalExpenses[indexPath.row] is TripExpense {
            
            selectedIndex = indexPath.row
            
            performSegueWithIdentifier("showTripDetail", sender: self)
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    @IBAction func addNewExpense(sender: AnyObject) {
        
        performSegueWithIdentifier("showExpense", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTripDetail" {
            (segue.destinationViewController as! TripsViewController).tripIndex = selectedIndex!
        }
    }
    
}
