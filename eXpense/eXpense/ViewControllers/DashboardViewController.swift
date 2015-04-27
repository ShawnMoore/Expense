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
    let prototypeCellIdentifier = "expense_cells"
    
    // MARK: Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //retrieve the model from the AppDelegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        model = appDelegate.getModel()

//        model?.loadOneTimeExpensesFromURLString("http://dalemusser.com/test/json/test.json") {
//            (object, error) -> Void in
//            println("Success")
//        }
        
        model?.loadAllLocalExpenses("oneTimeExpenses", tripFilename: "tripExpenses")
        
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
        return 31
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(prototypeCellIdentifier) as! DashboardTableViewCell
        
//        cell.textLabel?.text = "Row #\(indexPath.row)"
//        cell.detailTextLabel?.text = "Subtitle #\(indexPath.row)"
        cell.cellImage.contentMode = UIViewContentMode.Center
        
        var image_to_use = indexPath.row % 7
        
        switch image_to_use {
        case 0:
            cell.cellImage.image = UIImage(named: "MealIcon")
        case 1:
            cell.cellImage.image = UIImage(named: "TransportationIcon")
        case 2:
            cell.cellImage.image = UIImage(named: "LodgingIcon")
        case 3:
            cell.cellImage.image = UIImage(named: "EntertainmentIcon")
        case 4:
            cell.cellImage.image = UIImage(named: "OtherIcon")
        case 5:
            cell.cellImage.image = UIImage(named: "PersonalIcon")
        default:
            cell.cellImage.image = UIImage(named: "TripIcon")
        }
        
        cell.titleLabel.text = "Row #\(indexPath.row)"
        cell.detailLabel.text = "Subtitle #\(indexPath.row)"
        
        return cell
        
    }
    
    @IBAction func addNewExpense(sender: AnyObject) {
        
        performSegueWithIdentifier("showExpense", sender: self)
    
    }
    
}
