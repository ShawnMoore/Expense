//
//  NewOneTimeTableViewController.swift
//  eXpense
//
//  Created by Megan Ritchey on 4/26/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class NewOneTimeTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, DatePickerTableViewCellDelegate, TextFieldTableViewCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //MARK: Variables
    var oneTime: OneTimeExpense?
    var newExpense: Bool = true
    var newExpenseTripId: Int?
    
    var receiptImage:UIImage?
    var isFirstPhoto = 0
    var imagePicker: UIImagePickerController!
    
    private var editingModeOn: Bool = true
    private var datePickerOn: Bool = false
    private var categoryPickerOn: Bool = false
    
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var dateFormatString = "MMMM dd, yyyy"
    private let costFormatter = NSNumberFormatter()
    
    private var model: Model?
    private var responderPurposeTextField: UITextField? = nil
    private var responderCostTextField: UITextField? = nil
    private var responderLocationTextField: UITextField? = nil
    private var responderTextView: UITextView? = nil
    //MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = oneTime?.name
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        model = appDelegate.getModel()
        
        dateFormatter.dateFormat = dateFormatString
        costFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        costFormatter.locale = NSLocale(localeIdentifier: "en_US")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 67.0
        
        if newExpense {
            oneTime = OneTimeExpense(forID: Model.oneTimeIndex--, name: "", amount: 0.0, date: NSDate(), createdAt: NSDate(), deleted: false, userId: Model.userId, category: "Other")
            
            if let tripId = newExpenseTripId {
                oneTime?.tripId = tripId
            }
        }
        
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        categoryPickerOn = false
        datePickerOn = false
        
        if responderPurposeTextField != nil {
            oneTime?.name = responderPurposeTextField!.text
            responderPurposeTextField?.resignFirstResponder()
            responderPurposeTextField = nil
        }
        
        if responderCostTextField != nil {
            oneTime?.amount = (responderCostTextField!.text as NSString).doubleValue
            responderCostTextField?.resignFirstResponder()
            responderCostTextField = nil
        }
        
        if responderLocationTextField != nil {
            oneTime?.location = responderLocationTextField!.text
            responderLocationTextField?.resignFirstResponder()
            responderLocationTextField = nil
        }
        
        if let controllers = (self.navigationController?.viewControllers as? [UIViewController]) {
            if !contains(controllers, self) {
                
                if newExpense {
                    if oneTime?.tripId == nil {
                        model?.oneTimeExpenses.append(self.oneTime!)
                    } else {
                        model?.tripExpenses[self.oneTime!.tripId!]?.oneTimeExpenses.append(self.oneTime!)
                    }
                }
            }
        }
        
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return (categoryPickerOn ? 4 : 3)
        case 1:
            return (datePickerOn ? 4 : 3)
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
                let purposeCell = tableView.dequeueReusableCellWithIdentifier("PurposeTextFieldCell", forIndexPath: indexPath) as? PurposeTextFieldTableViewCell
                
                purposeCell?.delegate = self
                
                if !newExpense {
                    purposeCell?.purposeTextField.text = oneTime!.name
                }
                
                cell = purposeCell
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as? UITableViewCell
                cell?.textLabel?.text = "Category:"
                
                cell?.detailTextLabel?.text = Category.Other.rawValue
                
                if oneTime != nil {
                    cell?.detailTextLabel?.text = oneTime?.category.rawValue
                }
                
                
            case 2:
                if categoryPickerOn {
                    let categoryPickerCell = tableView.dequeueReusableCellWithIdentifier("categoryPickerCell", forIndexPath: indexPath) as? PickerViewTableViewCell
                    
                    categoryPickerCell?.Picker.selectRow(5, inComponent: 0, animated: false)
                    
                    if oneTime != nil {
                        for i in 0...(Category.allValues.count-1) {
                            if oneTime?.category.rawValue == Category.allValues[i].rawValue {
                                categoryPickerCell?.Picker.selectRow(i, inComponent: 0, animated: false)
                            }
                        }
                    }
                    
                    cell = categoryPickerCell
                } else {
                    let costCell = tableView.dequeueReusableCellWithIdentifier("CostTextFieldCell", forIndexPath: indexPath) as? CostTextFieldTableViewCell
                    
                    costCell?.delegate = self
                    
                    if !newExpense {
                        costCell?.costTextField.text = costFormatter.stringFromNumber(oneTime!.amount)
                    }
                    
                    cell = costCell
                }
            case 3:

                let costCell = tableView.dequeueReusableCellWithIdentifier("CostTextFieldCell", forIndexPath: indexPath) as? CostTextFieldTableViewCell
                
                costCell?.delegate = self
                
                if !newExpense {
                    costCell?.costTextField.text = costFormatter.stringFromNumber(oneTime!.amount)
                }
                
                cell = costCell
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
            }
            
        case 1:
            
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("tripCell", forIndexPath: indexPath) as? UITableViewCell
                cell?.textLabel?.text = "Trip:"
                if oneTime != nil {
                    if oneTime!.tripId == nil {
                        cell?.detailTextLabel?.text = "None"
                    }
                    else{
                        cell?.detailTextLabel?.text = model?.tripExpenses[oneTime!.tripId!]!.name
                    }
                } else {
                    cell?.detailTextLabel?.text = "None"
                }
                
            case 1:
                let locationCell = tableView.dequeueReusableCellWithIdentifier("LocationTextFieldCell", forIndexPath: indexPath) as? LocationTableViewCell
                
                locationCell?.delegate = self
                
                if !newExpense {
                    if let location = oneTime?.location {
                        locationCell?.locationTextField.text = location
                    }
                }
                
                cell = locationCell
            case 2:
                cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as? UITableViewCell
                cell?.textLabel?.text = "Date:"
                
                if oneTime != nil {
                    cell?.detailTextLabel?.text = dateFormatter.stringFromDate(oneTime!.date)
                } else {
                    cell?.detailTextLabel?.text = dateFormatter.stringFromDate(NSDate())
                }
                
            case 3:
                cell = tableView.dequeueReusableCellWithIdentifier("datePickerCell", forIndexPath: indexPath) as? DatePickerTableViewCell
                
                if !newExpense {
                    (cell as! DatePickerTableViewCell).datePicker.date = oneTime!.date
                }
    
                (cell as! DatePickerTableViewCell).identifier = "datePicker"
                (cell as! DatePickerTableViewCell).delegate = self
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                let descriptionCell = tableView.dequeueReusableCellWithIdentifier("textAreaCell", forIndexPath: indexPath) as? TextAreaTableViewCell
                descriptionCell?.textAreaLabel.text = "Description:"
                
                if oneTime != nil {
                        descriptionCell?.textArea.text = oneTime?.expenseDescription
                }
                
                cell = descriptionCell
                
            case 1:
                let photoCell = tableView.dequeueReusableCellWithIdentifier("photoCaptureCell", forIndexPath: indexPath) as? PhotoCaptureTableViewCell
                
                if isFirstPhoto == 1 {
                    photoCell?.receiptImageView.image = receiptImage
                    photoCell?.receiptImageView.contentMode = .ScaleAspectFit
                    photoCell?.takePhotoButton.setTitle("", forState: UIControlState.Normal)
                }
                
                cell = photoCell
                
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
            }

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
        
        if let textField = responderCostTextField {
            textField.resignFirstResponder()
            responderCostTextField = nil
        }
        
        if let textField = responderLocationTextField {
            textField.resignFirstResponder()
            responderLocationTextField = nil
        }
        
        if let textView = responderTextView {
            textView.resignFirstResponder()
            responderTextView = nil
        }

        if(indexPath.section == 1 && indexPath.row == 0){
            performSegueWithIdentifier("tripSelection", sender: self)
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: UITableViewRowAnimation.None)
        }
        else{
            var (path, action) = getIndexPathOnGlobalBools(indexPath)
            if(action == "insert"){
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths([path], withRowAnimation: .Fade)
                tableView.endUpdates()
                tableView.scrollToRowAtIndexPath(path, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            } else if(action == "delete") {
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([path], withRowAnimation: .Fade)
                tableView.endUpdates()
            }
        }
    }
    
    //MARK: Picker View Functions
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.allValues.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var pickerData = Category.allValues
        return pickerData[row].rawValue
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if oneTime != nil {
            oneTime?.category = Category.allValues[row]
        }
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    //MARK: Text View Functions
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.responderTextView = textView
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
        
        oneTime?.expenseDescription = textView.text
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.responderTextView = nil
    }
    
    //MARK: Image Picker Functions
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        //set image
        receiptImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        isFirstPhoto = 1
        
        //dismiss camera view
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }

    //MARK: IBAction Function
    @IBAction func takeReceiptPhoto(sender: AnyObject) {
        if isFirstPhoto == 0 {
            //camera detected
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
                var picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = UIImagePickerControllerSourceType.Camera
                var mediaTypes: Array<AnyObject> = [kUTTypeImage]
                picker.mediaTypes = mediaTypes
                picker.allowsEditing = false
                self.presentViewController(picker, animated: true, completion: nil)
            }
                
                //no camera detected
            else{
                var alert = UIAlertController(title: "No Camera", message: "Your device must have a camera to take a picture of your reciepts", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        else if isFirstPhoto == 1 {
            performSegueWithIdentifier("showReceipt", sender: self)
        }
        
    }
    
    //MARK: Additional Delegate Functions
    func dateAndTimeHasChanged(ChangedTo: NSDate, at: String) {
        oneTime?.date = ChangedTo
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 1)], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    func textInTextFieldHasChanged(ChangedTo: String, at: String) {
        if at == "Purpose" {
            oneTime?.name = ChangedTo
        } else if at == "Cost" {
            var removeDollarSign = ChangedTo as NSString
            var checkDollar = removeDollarSign as String
            if checkDollar[checkDollar.startIndex] == "$" {
                removeDollarSign = removeDollarSign.substringFromIndex(1)
            }
            removeDollarSign = removeDollarSign.stringByReplacingOccurrencesOfString(",", withString: "")
            
            if removeDollarSign != "" {
                oneTime?.amount = (removeDollarSign).doubleValue
            }
            else {
                oneTime?.amount = 0.00
            }
        } else if at == "Location" {
            if !ChangedTo.isEmpty {
                oneTime?.location = ChangedTo
            }
        }
    }
    
    func updateFirstResponder(textField: UITextField, identifier: String) {
        
        if identifier == "Purpose_Begin" {
            oneTime?.name = textField.text
            self.responderPurposeTextField = textField
        } else if identifier == "Purpose_End" {
            oneTime?.name = textField.text
            self.responderPurposeTextField = nil
        }
        
        if identifier == "Cost_Begin" {
            if textField.text != "" {
                oneTime?.amount = (textField.text as NSString).doubleValue
            }
            self.responderCostTextField = textField
        } else if identifier == "Cost_End" {
            if textField.text != "" {
                var removeDollarSign = textField.text as NSString
                var checkDollar = removeDollarSign as String
                if checkDollar[checkDollar.startIndex] == "$" {
                    removeDollarSign = removeDollarSign.substringFromIndex(1)
                }
                removeDollarSign = removeDollarSign.stringByReplacingOccurrencesOfString(",", withString: "")
                
                if removeDollarSign != "" {
                    oneTime?.amount = removeDollarSign.doubleValue
                }
                else {
                    oneTime?.amount = 0.00
                }
            }
            else {
                oneTime?.amount = 0.00
            }
            self.responderCostTextField = nil
        }
        
        if identifier == "Location_Begin" {
            oneTime?.location = textField.text
            self.responderLocationTextField = textField
        } else if identifier == "Location_End" {
            oneTime?.location = textField.text
            self.responderLocationTextField = nil
        }
    }
    
    //MARK: Prepare for Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tripSelection" {
            (segue.destinationViewController as! TripsChoiceTableViewController).oneTimeExpense = oneTime
        }
        if segue.identifier == "showReceipt" {
            let destViewController = segue.destinationViewController as! ReceiptViewController
            destViewController.receiptImage = receiptImage
            destViewController.previousViewController = self
        }
    }
    
    //MARK: Utility Functions
    func getIndexPathOnGlobalBools(indexPath: NSIndexPath) -> (NSIndexPath, String){
        
        let insert = "insert"
        let delete = "delete"
        let categoryPath = NSIndexPath(forRow: 2, inSection: 0)
        let datePath = NSIndexPath(forRow: 3, inSection: 1)
        
        if indexPath.section == 0 && indexPath.row == 1{
            
            categoryPickerOn = !categoryPickerOn
            
            if categoryPickerOn {
                return (categoryPath, insert)
            } else {
                return (categoryPath, delete)
            }
        }
        
        if indexPath.section == 1 && indexPath.row == 2 {
            datePickerOn = !datePickerOn
            
            if datePickerOn {
                return (datePath, insert)
            } else {
                return (datePath, delete)
            }
        }
        return(NSIndexPath(forRow: 0, inSection: 0), "Error")
    }
    
}