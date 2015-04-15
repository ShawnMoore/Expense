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
        
//        techCompanies.load(urlString) {
//            (companies, errorString) -> Void in
//            if let unwrappedErrorString = errorString {
//                // can do something about error here
//                println(unwrappedErrorString)
//            } else {
//                self.regionsTableView.reloadData()
//            }
//        }
        
//        model?.loadOneTimeExpensesFromLocalFile("oneTimeExpenses") {
//            (object, error) -> Void in
//            println("Success")
//        }
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 31
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(prototypeCellIdentifier) as! UITableViewCell
        
        cell.textLabel?.text = "Row #\(indexPath.row)"
        cell.detailTextLabel?.text = "Subtitle #\(indexPath.row)"
        
        return cell
        
    }
    
    @IBAction func addNewExpense(sender: AnyObject) {
        
        performSegueWithIdentifier("showExpense", sender: self)
    
    }
    
}
