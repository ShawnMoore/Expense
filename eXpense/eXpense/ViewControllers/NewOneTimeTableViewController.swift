//
//  NewOneTimeTableViewController.swift
//  eXpense
//
//  Created by Megan Ritchey on 4/26/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class NewOneTimeTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {
    
    var datePickerOn: Bool = false
    var categoryPickerOn: Bool = false
    
    var expenseModel: OneTimeExpense?
    
    var model: Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        model = appDelegate.getModel()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 67.0
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            if(categoryPickerOn){
                return 4
            }
            else{
                return 3
            }
        case 1:
            if(datePickerOn){
                return 4
            }
            else{
                return 3
            }
        case 2:
            return 2
        default:
            return 1
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let purposeCell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
                purposeCell?.cellTextField.placeholder = "Purpose"
                cell = purposeCell
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as? UITableViewCell
                cell?.textLabel?.text = "Category:"
                cell?.detailTextLabel?.text = Category.Other.rawValue
            case 2:
                if categoryPickerOn {
                    let catPickerCell = tableView.dequeueReusableCellWithIdentifier("categoryPickerCell", forIndexPath: indexPath) as? PickerViewTableViewCell
                    cell = catPickerCell
                } else {
                    let costCell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
                    costCell?.cellTextField.placeholder = "Cost"
                    cell = costCell
                }
            case 3:
                let costCell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
                costCell?.cellTextField.placeholder = "Cost"
                cell = costCell
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
            }
            
        case 1:
            
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("tripCell", forIndexPath: indexPath) as? UITableViewCell
                cell?.textLabel?.text = "Trip:"
                cell?.detailTextLabel?.text = "none"
                
            case 1:
                let locationCell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
                locationCell?.cellTextField.placeholder = "Location"
                cell = locationCell
            case 2:
                cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as? UITableViewCell
                cell?.textLabel?.text = "Date:"
                cell?.detailTextLabel?.text = "NOT DONE YET"
            case 3:
                cell = tableView.dequeueReusableCellWithIdentifier("datePickerCell", forIndexPath: indexPath) as? DatePickerTableViewCell
                (cell as! DatePickerTableViewCell).location = indexPath
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                let descriptionCell = tableView.dequeueReusableCellWithIdentifier("textAreaCell", forIndexPath: indexPath) as? TextAreaTableViewCell
                descriptionCell?.textAreaLabel.text = "Description:"
                cell = descriptionCell
                
            case 1:
                let photoCell = tableView.dequeueReusableCellWithIdentifier("photoCaptureCell", forIndexPath: indexPath) as? PhotoCaptureTableViewCell
                cell = photoCell
                
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
            }

        default:
            cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? UITableViewCell
            cell?.textLabel?.text = "Say Hi"
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let categoryPath = [NSIndexPath(forRow: 2, inSection: 0)]
        let datePath = [NSIndexPath(forRow: 3, inSection: 1)]
        
        if indexPath.section == 0 && indexPath.row == 1{
            categoryPickerOn = !categoryPickerOn
            
            if categoryPickerOn {
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths(categoryPath, withRowAnimation: .Fade)
                tableView.endUpdates()
            } else {
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths(categoryPath, withRowAnimation: .Fade)
                tableView.endUpdates()
            }
        }
        
        if indexPath.section == 1 && indexPath.row == 2 {
            datePickerOn = !datePickerOn
            
            if datePickerOn {
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths(datePath, withRowAnimation: .Fade)
                tableView.endUpdates()
            } else {
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths(datePath, withRowAnimation: .Fade)
                tableView.endUpdates()
            }
        }
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.allValues.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var pickerData = Category.allValues
        return pickerData[row].rawValue
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0))
        print(Category.allValues[row].rawValue)
        cell.detailTextLabel?.text = Category.allValues[row].rawValue
        tableView.reloadData()
    }
    
    func textViewDidChange(textView: UITextView) {
        tableView.beginUpdates()
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        tableView.endUpdates()
        
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