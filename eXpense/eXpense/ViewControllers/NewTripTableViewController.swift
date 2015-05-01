//
//  NewTripTableViewController.swift
//  eXpense
//
//  Created by Megan Ritchey on 4/27/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class NewTripTableViewController: UITableViewController, UITextViewDelegate, DatePickerTableViewCellDelegate/*, TextFieldTableViewCellDelegate*/ {

    var startDatePickerOn: Bool = false
    var endDatePickerOn: Bool = false
    
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var dateFormatString = "MMMM dd, yyyy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 67.0

        dateFormatter.dateFormat = dateFormatString
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        tableView.reloadData()
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
            return 2
        case 1:
            
            if(startDatePickerOn && endDatePickerOn){
                return 4
            }
            else if (startDatePickerOn || endDatePickerOn){
                return 3
            }
            else{
                return 2
            }
        case 2:
            return 1
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
                let nameCell = tableView.dequeueReusableCellWithIdentifier("PurposeTextFieldCell", forIndexPath: indexPath) as? PurposeTextFieldTableViewCell
                nameCell?.purposeTextField.placeholder = "Name"
                cell = nameCell
            case 1:
                let locationCell = tableView.dequeueReusableCellWithIdentifier("LocationTextFieldCell", forIndexPath: indexPath) as? LocationTableViewCell
                cell = locationCell
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
            }
            
        case 1:
            
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as? UITableViewCell
                cell?.textLabel?.text = "Start Date:"
                cell?.detailTextLabel?.text = "NOT DONE YET"
                
            case 1:
                if(startDatePickerOn){
                    cell = tableView.dequeueReusableCellWithIdentifier("datePickerCell", forIndexPath: indexPath) as? DatePickerTableViewCell
                    (cell as! DatePickerTableViewCell).delegate = self
                    (cell as! DatePickerTableViewCell).identifier = "Start"
                }else{
                    cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as? UITableViewCell
                    cell?.textLabel?.text = "End Date:"
                    cell?.detailTextLabel?.text = "NOT DONE YET"
                }
            case 2:
                if(startDatePickerOn){
                    cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as? UITableViewCell
                    cell?.textLabel?.text = "End Date:"
                    cell?.detailTextLabel?.text = "NOT DONE YET"
                }else if(endDatePickerOn){
                    cell = tableView.dequeueReusableCellWithIdentifier("datePickerCell", forIndexPath: indexPath) as? DatePickerTableViewCell
                    (cell as! DatePickerTableViewCell).delegate = self
                    (cell as! DatePickerTableViewCell).identifier = "End"
                }
            case 3:
                if(endDatePickerOn){
                    cell = tableView.dequeueReusableCellWithIdentifier("datePickerCell", forIndexPath: indexPath) as? DatePickerTableViewCell
                    (cell as! DatePickerTableViewCell).delegate = self
                    (cell as! DatePickerTableViewCell).identifier = "End"
                }
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
            }
            
        case 2:
            let descriptionCell = tableView.dequeueReusableCellWithIdentifier("textAreaCell", forIndexPath: indexPath) as? TextAreaTableViewCell
            descriptionCell?.textAreaLabel.text = "Description:"
            cell = descriptionCell
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? UITableViewCell
            cell?.textLabel?.text = "Say Hi"
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
       
        var (path, action) = getIndexPathOnGlobalBools(indexPath)
        if(action == "insert"){
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([path], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
        else if(action == "delete"){
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([path], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
        
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func textViewDidChange(textView: UITextView) {
        tableView.beginUpdates()
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        tableView.endUpdates()
    }
    
    func getIndexPathOnGlobalBools(indexPath: NSIndexPath) -> (NSIndexPath, String){
        
        let startDatePath = NSIndexPath(forRow: 1, inSection: 1)
        let endDatePath1 = NSIndexPath(forRow: 2, inSection: 1)
        let endDatePath2 = NSIndexPath(forRow: 3, inSection: 1)
        let insert = "insert"
        let delete = "delete"
        
        if indexPath.section == 1 && indexPath.row == 0{
            startDatePickerOn = !startDatePickerOn
            
            if startDatePickerOn {
                return (startDatePath, insert)
            } else {
                return (startDatePath, delete)
            }
        }
        else if indexPath.section == 1 && indexPath.row == 1{
            
            if !startDatePickerOn {
                endDatePickerOn = !endDatePickerOn
                if endDatePickerOn  {
                    return (endDatePath1, insert)
                }else{
                    return (endDatePath1, delete)
                }
            }
        }
        else if indexPath.section == 1 && indexPath.row == 2{
            endDatePickerOn = !endDatePickerOn
            
            if endDatePickerOn {
                return (endDatePath2, insert)
            } else {
                return (endDatePath2, delete)
            }
        }
        return(NSIndexPath(forRow: 0, inSection: 0), "Error")
    }
    
    func dateAndTimeHasChanged(ChangedTo: NSDate, at: String) {
        if at == "Start" {
            println("Start Value")
        } else if at == "End" {
            println("End Value")
        }
    }


}
