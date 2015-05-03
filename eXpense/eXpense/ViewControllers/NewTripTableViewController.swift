//
//  NewTripTableViewController.swift
//  eXpense
//
//  Created by Megan Ritchey on 4/27/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class NewTripTableViewController: UITableViewController, UITextViewDelegate, DatePickerTableViewCellDelegate, TextFieldTableViewCellDelegate {
    //MARK: Variables
    private var startDatePickerOn: Bool = false
    private var endDatePickerOn: Bool = false
    
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var dateFormatString = "MMMM dd, yyyy"
    
    private var model: Model?
    private var responderPurposeTextField: UITextField? = nil
    private var responderLocationTextField: UITextField? = nil
    private var responderTextView: UITextView? = nil
    
    var trip: TripExpense?
    var newTrip: Bool = true
    
    var oneTimeExpense: OneTimeExpense? = nil
    
    //MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = trip?.name
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        model = appDelegate.getModel()

        dateFormatter.dateFormat = dateFormatString
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 67.0
        
        if newTrip {
            trip = TripExpense(forName: "", id: Model.tripIndex--, startDate: NSDate(), createdAt: NSDate(), deleted: false, userId: Model.userId, isComplete: false)
        }
        editableCheck()
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        if responderPurposeTextField != nil {
            trip?.name = responderPurposeTextField!.text
            responderPurposeTextField?.resignFirstResponder()
            responderPurposeTextField = nil
        }
        
        if responderLocationTextField != nil {
            trip?.location = responderLocationTextField!.text
            responderLocationTextField?.resignFirstResponder()
            responderLocationTextField = nil
        }
        
        var selectedId: Int? = nil
        
        if trip != nil {
            if !trip!.name.isEmpty {
                model?.tripExpenses[trip!.id] = trip
                selectedId = trip!.id
            } else {
                selectedId = nil
            }
        }
        
        if selectedId != nil {
            oneTimeExpense?.tripId = selectedId
        }
    }

    //MARK: Table View Functions

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
                cell =  tableView.dequeueReusableCellWithIdentifier("PurposeTextFieldCell", forIndexPath: indexPath) as? UITableViewCell
                cell = createNameCell(cell!)
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier("LocationTextFieldCell", forIndexPath: indexPath) as? UITableViewCell
                cell = createLocationCell(cell!)
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
            }
            
        case 1:
            
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as? UITableViewCell
                cell = createStartDateCell(cell!)
                
            case 1:
                if(startDatePickerOn){
                    cell = tableView.dequeueReusableCellWithIdentifier("datePickerCell", forIndexPath: indexPath) as? UITableViewCell
                    cell = createStartDatePicker(cell!)
                }else{
                    cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as? UITableViewCell
                    cell = createEndDateCell(cell!)
                }
            case 2:
                if(startDatePickerOn){
                    cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as? UITableViewCell
                    cell = createEndDateCell(cell!)
                }else if(endDatePickerOn){
                    cell = tableView.dequeueReusableCellWithIdentifier("datePickerCell", forIndexPath: indexPath) as? UITableViewCell
                    cell = createEndDatePicker(cell!)
                }
            case 3:
                if(endDatePickerOn){
                    cell = tableView.dequeueReusableCellWithIdentifier("datePickerCell", forIndexPath: indexPath) as? UITableViewCell
                    cell = createEndDatePicker(cell!)
                }
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
            }
            
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier("textAreaCell", forIndexPath: indexPath) as? UITableViewCell
            cell = createDescriptionCell(cell!)
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? UITableViewCell
            cell?.textLabel?.text = ""
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
       
        if let textField = responderPurposeTextField {
            textField.resignFirstResponder()
            responderPurposeTextField = nil
        }
        
        if let textField = responderLocationTextField {
            textField.resignFirstResponder()
            responderLocationTextField = nil
        }
        
        if let textView = responderTextView {
            textView.resignFirstResponder()
            responderTextView = nil
        }
        
        var (path, action) = getIndexPathOnGlobalBools(indexPath)
        if(action == "insert"){
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([path], withRowAnimation: .Fade)
            tableView.endUpdates()
            tableView.scrollToRowAtIndexPath(path, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
        else if(action == "delete"){
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([path], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
        
    }
    
    //MARK: Text View Functions
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.responderTextView = textView
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
        
        trip?.expenseDescription = textView.text
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.responderTextView = nil
    }
    
    //MARK: Additional Delegate Functions
    func dateAndTimeHasChanged(ChangedTo: NSDate, at: String) {
        if at == "Start" {
            trip?.date = ChangedTo
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: UITableViewRowAnimation.None)
        } else if at == "End" {
            trip?.endDate = ChangedTo
            
            if startDatePickerOn {
                tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 1)], withRowAnimation: UITableViewRowAnimation.None)
            } else {
                tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.None)
            }
            
        }
    }
    
    func textInTextFieldHasChanged(ChangedTo: String, at: String) {
        if at == "Purpose" {
            trip?.name = ChangedTo
            self.title = ChangedTo
        } else if at == "Location" {
            if !ChangedTo.isEmpty {
                trip?.location = ChangedTo
            }
        }
    }
    
    func updateFirstResponder(textField: UITextField, identifier: String) {
        
        if identifier == "Purpose_Begin" {
            trip?.name = textField.text
            self.title = textField.text
            self.responderPurposeTextField = textField
        } else if identifier == "Purpose_End" {
            trip?.name = textField.text
            self.title = textField.text
            self.responderPurposeTextField = nil
        }
        
        if identifier == "Location_Begin" {
            trip?.location = textField.text
            self.responderLocationTextField = textField
        } else if identifier == "Location_End" {
            trip?.location = textField.text
            self.responderLocationTextField = nil
        }
        
    }

    
    //MARK: Utility Functions
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
            if(startDatePickerOn){
                endDatePickerOn = !endDatePickerOn
            
                if endDatePickerOn {
                    return (endDatePath2, insert)
                } else {
                    return (endDatePath2, delete)
                }
            }
        }
        return(NSIndexPath(forRow: 0, inSection: 0), "Error")
    }
    
    func createNameCell(cell: UITableViewCell) -> UITableViewCell{
        let nameCell = cell as? PurposeTextFieldTableViewCell
        nameCell?.delegate = self
        if trip != nil {
            nameCell?.purposeTextField.text = trip?.name
        }
        return nameCell!
    }
    
    func createLocationCell(cell: UITableViewCell) -> UITableViewCell{
        let locationCell = cell as? LocationTableViewCell
        locationCell?.delegate = self
        if trip != nil {
            locationCell?.locationTextField.text = trip?.location
        }
        return locationCell!
    }
    
    func createStartDateCell(cell: UITableViewCell) -> (UITableViewCell){
        cell.textLabel?.text = "Start Date:"
        if trip != nil {
            cell.detailTextLabel?.text = dateFormatter.stringFromDate(trip!.date)
        } else {
            cell.detailTextLabel?.text = dateFormatter.stringFromDate(NSDate())
        }
        return cell
    }
    
    func createStartDatePicker(cell: UITableViewCell) -> (UITableViewCell){
        let datePickerCell = cell as? DatePickerTableViewCell
        if !newTrip {
            datePickerCell?.datePicker.date = trip!.date
        }
        datePickerCell?.delegate = self
        datePickerCell?.identifier = "Start"
        return datePickerCell!
    }
    
    func createEndDatePicker(cell: UITableViewCell) -> (UITableViewCell){
        let datePickerCell = cell as? DatePickerTableViewCell
        if trip!.endDate == nil {
            datePickerCell?.datePicker.date = trip!.date
        } else {
            datePickerCell?.datePicker.date = trip!.endDate!
        }
        datePickerCell?.delegate = self
        datePickerCell?.identifier = "End"
        return datePickerCell!
    }
    
    func createEndDateCell(cell: UITableViewCell) -> (UITableViewCell){
        cell.textLabel?.text = "End Date:"
        if trip != nil {
            if let endDate = trip?.endDate {
                cell.detailTextLabel?.text = dateFormatter.stringFromDate(endDate)
            } else {
                cell.detailTextLabel?.text = "Not Yet Set"
            }
        } else {
            cell.detailTextLabel?.text = "Not Yet Set"
        }
        return cell
    }
    
    func createDescriptionCell(cell: UITableViewCell) -> (UITableViewCell){
        let descriptionCell = cell as? TextAreaTableViewCell
        descriptionCell?.textAreaLabel.text = "Description:"
        if trip != nil {
            descriptionCell?.textArea.text = trip?.expenseDescription
        }
        return descriptionCell!
    }
    
    func editableCheck(){
        if trip!.isApproved != nil && trip!.isApproved!{
            tableView.userInteractionEnabled = false
        } else {
            tableView.userInteractionEnabled = true
        }
    }
}
