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
    var receiptImageOrient: Int?
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
        
        if oneTime != nil {
            if !oneTime!.name.isEmpty {
                self.title = oneTime?.name
            } else {
                self.title = "Purpose is Required"
            }
        }
        
        //if photo is stored, assign it to receiptImage
        if isFirstPhoto == 0 && (oneTime?.photoURI != "" && oneTime?.photoURI != nil) {
            let decodedData = NSData(base64EncodedString: oneTime!.photoURI!, options: NSDataBase64DecodingOptions(rawValue: 0))
            if decodedData != nil {
                var decodedimage = UIImage(data: decodedData!)
                receiptImage = decodedimage
                receiptImageOrient = oneTime?.photoOrientation
                isFirstPhoto = 1
            }
        }
        
        tableView.reloadData()
        
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
    }
   
    //encode receiptImage in viewDIDdisappear to save some time
    override func viewDidDisappear(animated: Bool) {
        if receiptImage != nil && receiptImage != "" {
            var imageData = UIImagePNGRepresentation(receiptImage)
            let base64String = imageData.base64EncodedStringWithOptions(.allZeros)
            oneTime?.photoURI = base64String
            oneTime?.photoOrientation = receiptImageOrient
        }
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
                } else {
                    model?.updateModel()
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
                cell = tableView.dequeueReusableCellWithIdentifier("PurposeTextFieldCell", forIndexPath: indexPath) as? UITableViewCell
                cell = createPurposeCell(cell!)
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as? UITableViewCell
                cell = createCategoryCell(cell!)
            case 2:
                if categoryPickerOn {
                    cell = tableView.dequeueReusableCellWithIdentifier("categoryPickerCell", forIndexPath: indexPath) as? UITableViewCell
                    cell = createCategoryPickerCell(cell!)
                } else {
                    cell = tableView.dequeueReusableCellWithIdentifier("CostTextFieldCell", forIndexPath: indexPath) as? UITableViewCell
                    cell = createCostCell(cell!)
                }
            case 3:
                cell = tableView.dequeueReusableCellWithIdentifier("CostTextFieldCell", forIndexPath: indexPath) as? UITableViewCell
                cell = createCostCell(cell!)
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("tripCell", forIndexPath: indexPath) as? UITableViewCell
                cell = createTripCell(cell!)
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier("LocationTextFieldCell", forIndexPath: indexPath) as? UITableViewCell
                cell = createLocationCell(cell!)
            case 2:
                cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as? UITableViewCell
                cell = createDateCell(cell!)
            case 3:
                cell = tableView.dequeueReusableCellWithIdentifier("datePickerCell", forIndexPath: indexPath) as? DatePickerTableViewCell
                cell = createDatePickerCell(cell!)
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
            }
            
        case 2:
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("textAreaCell", forIndexPath: indexPath) as? UITableViewCell
                cell = createDescriptionCell(cell!)
                
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier("photoCaptureCell", forIndexPath: indexPath) as? UITableViewCell
                cell = createPhotoCell(cell!)
                
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
        receiptImageOrient = receiptImage?.imageOrientation.rawValue
        isFirstPhoto = 1
        
        //dismiss camera view
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }

    //MARK: IBAction Function
    @IBAction func takeReceiptPhoto(sender: AnyObject) {
        if isFirstPhoto == 0 && (oneTime?.photoURI != "" && oneTime?.photoURI != nil){
            performSegueWithIdentifier("showReceipt", sender: self)
        }
            
        else if isFirstPhoto == 0 {
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

        else {
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
            self.title = ChangedTo
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
            self.title = textField.text
            self.responderPurposeTextField = textField
        } else if identifier == "Purpose_End" {
            oneTime?.name = textField.text
            self.title = textField.text
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
            destViewController.receiptImageOrient = receiptImageOrient
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
    
    func createPurposeCell(cell: UITableViewCell) -> (UITableViewCell){
        let purposeCell = cell as? PurposeTextFieldTableViewCell
        purposeCell?.delegate = self
        if !newExpense {
            purposeCell?.purposeTextField.text = oneTime!.name
        }
        return purposeCell!
    }
    
    func createCategoryCell(cell: UITableViewCell) -> (UITableViewCell){
        cell.textLabel?.text = "Category:"
        cell.detailTextLabel?.text = Category.Other.rawValue
        
        if oneTime != nil {
            cell.detailTextLabel?.text = oneTime?.category.rawValue
        }
        return cell
    }

    func createCategoryPickerCell(cell: UITableViewCell) -> (UITableViewCell){
        let categoryPickerCell = cell as? PickerViewTableViewCell
        categoryPickerCell?.Picker.selectRow(5, inComponent: 0, animated: false)
        if oneTime != nil {
            for i in 0...(Category.allValues.count-1) {
                if oneTime?.category.rawValue == Category.allValues[i].rawValue {
                    categoryPickerCell?.Picker.selectRow(i, inComponent: 0, animated: false)
                }
            }
        }
        return categoryPickerCell!
    }
    
    func createCostCell(cell: UITableViewCell) -> (UITableViewCell){
        let costCell = cell as? CostTextFieldTableViewCell
        costCell?.delegate = self
        if !newExpense {
            costCell?.costTextField.text = costFormatter.stringFromNumber(oneTime!.amount)
        }
        if oneTime!.amount != 0 {
            var tempAmount = String(format:"%.0f", oneTime!.amount * 100)
            costCell?.costString = "\(tempAmount)"
        }
        return costCell!
    }
    
    func createTripCell(cell: UITableViewCell) -> (UITableViewCell){
        cell.textLabel?.text = "Trip:"
        if oneTime != nil {
            if oneTime!.tripId == nil {
                cell.detailTextLabel?.text = "None"
            }
            else{
                cell.detailTextLabel?.text = model?.tripExpenses[oneTime!.tripId!]!.name
            }
        } else {
            cell.detailTextLabel?.text = "None"
        }
        return cell
    }
    
    func createLocationCell(cell: UITableViewCell) -> (UITableViewCell){
        let locationCell = cell as? LocationTableViewCell
        locationCell?.delegate = self
        if !newExpense {
            if let location = oneTime?.location {
                locationCell?.locationTextField.text = location
            }
        }
        return locationCell!
    }
    
    func createDateCell(cell: UITableViewCell) -> (UITableViewCell){
        cell.textLabel?.text = "Date:"
        if oneTime != nil {
            cell.detailTextLabel?.text = dateFormatter.stringFromDate(oneTime!.date)
        } else {
            cell.detailTextLabel?.text = dateFormatter.stringFromDate(NSDate())
        }
        return cell
    }
    
    func createDatePickerCell(cell: UITableViewCell) -> (UITableViewCell){
        let datePickerCell = cell as? DatePickerTableViewCell
        if !newExpense {
            datePickerCell?.datePicker.date = oneTime!.date
        }
        datePickerCell?.identifier = "datePicker"
        datePickerCell?.delegate = self
        return datePickerCell!
    }
    
    func createDescriptionCell(cell: UITableViewCell) -> (UITableViewCell){
        let descriptionCell = cell as? TextAreaTableViewCell
        descriptionCell?.textAreaLabel.text = "Description:"
        if oneTime != nil {
            descriptionCell?.textArea.text = oneTime?.expenseDescription
        }
        return descriptionCell!
    }
    
    func createPhotoCell(cell: UITableViewCell) -> (UITableViewCell){
        let photoCell = cell as? PhotoCaptureTableViewCell
        if isFirstPhoto == 0 && (oneTime?.photoURI != "" && oneTime?.photoURI != nil) {
            photoCell?.takePhotoButton.setTitle("", forState: UIControlState.Normal)
            photoCell?.receiptImageView.image = receiptImage
            photoCell?.receiptImageView.contentMode = .ScaleAspectFit
        }
        else if isFirstPhoto == 1 {
            photoCell?.receiptImageView.image = receiptImage
            photoCell?.receiptImageView.contentMode = .ScaleAspectFit
            photoCell?.takePhotoButton.setTitle("", forState: UIControlState.Normal)
            
            //rotate portrait back from landscape after encoding
            if receiptImageOrient == 3 {
                if receiptImage?.imageOrientation.rawValue == 0 {
                    var rotateImage = UIImage(CGImage: receiptImage?.CGImage, scale: receiptImage!.scale, orientation: UIImageOrientation.Right)
                    receiptImage = rotateImage
                }
            }
        }
        else {
            photoCell?.takePhotoButton.setTitle("Take a Photo of the Receipt", forState: UIControlState.Normal)
        }
        return photoCell!
    }
    
    
    @IBAction func Submit(sender: AnyObject) {
        submissionCheck()
    }
    //MARK: Submission Functions
    func submissionCheck(){
        var nameString = oneTime?.name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var locationString = oneTime?.location?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if let nameIsEmpty = nameString?.isEmpty,
            locationIsEmpty = locationString?.isEmpty{
                if(!nameIsEmpty && !locationIsEmpty && oneTime?.amount > 0.00){
                    return
                }
        }
        var alert = UIAlertView(title: "Invalid Submission", message: "Please make sure you have entered in a purpose, location, and amount.", delegate: self, cancelButtonTitle: "Okay")
        alert.show()
    }

}