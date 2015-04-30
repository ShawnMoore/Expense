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
    
    private var editingModeOn: Bool = true
    private var datePickerOn: Bool = false
    private var categoryPickerOn: Bool = false
    
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var dateFormatString = "MMMM dd, yyyy"
    
    var oneTime: OneTimeExpense?
    var newExpense: Bool = true
    
    var receiptImage:UIImage?
    var isFirstPhoto = 0
    var imagePicker: UIImagePickerController!
    
    private var model: Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        model = appDelegate.getModel()
        
        dateFormatter.dateFormat = dateFormatString
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 67.0
        
        if newExpense {
            oneTime = OneTimeExpense(forID: Model.oneTimeIndex--, name: "", amount: 0.0, date: NSDate(), createdAt: NSDate(), deleted: false, userId: Model.userId, category: "Other")
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        if let controllers = (self.navigationController?.viewControllers as? [UIViewController]) {
            if !contains(controllers, self) {
                
                var cell = (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TextFieldTableViewCell)
                oneTime?.name = cell.cellTextField.text
                cell = (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! TextFieldTableViewCell)
                oneTime?.amount = (cell.cellTextField.text as NSString).doubleValue
                cell = (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) as! TextFieldTableViewCell)
                oneTime?.location = cell.cellTextField.text
                
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
                
                purposeCell?.delegate = self
                purposeCell?.identifier = "Purpose"
                
                purposeCell?.cellTextField.placeholder = "Purpose"
                
                if !newExpense {
                    purposeCell?.cellTextField.text = oneTime!.name
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
                    let costCell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
                    
                    costCell?.delegate = self
                    costCell?.identifier = "Cost"
                    
                    costCell?.cellTextField.placeholder = "Cost"
                    
                    if !newExpense {
                        costCell?.cellTextField.text = String(format:"%.2f", oneTime!.amount)
                    }
                    
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
                let locationCell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as? TextFieldTableViewCell
                
                locationCell?.delegate = self
                locationCell?.identifier = "Location"
                
                locationCell?.cellTextField.placeholder = "Location"
                
                if !newExpense {
                    if let location = oneTime?.location {
                        locationCell?.cellTextField.text = location
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
    
                (cell as! DatePickerTableViewCell).location = indexPath
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
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        if(indexPath.section == 1 && indexPath.row == 0){
            performSegueWithIdentifier("tripSelection", sender: self)
            tableView.reloadData()
        }
        else{
            var (path, action) = getIndexPathOnGlobalBools(indexPath)
            if(action == "insert"){
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths([path], withRowAnimation: .Fade)
                tableView.endUpdates()
                tableView.scrollToRowAtIndexPath(path, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
            } else if(action == "delete") {
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([path], withRowAnimation: .Fade)
                tableView.endUpdates()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tripSelection" {
            (segue.destinationViewController as! TripsChoiceTableViewController).oneTimeExpense = oneTime
        }
        if segue.identifier == "showReceipt" {
            let destViewController = segue.destinationViewController as! ReceiptViewController
            destViewController.receiptImage = receiptImage
            destViewController.previousViewController = self
            navigationItem.title = nil
        }
    }
    
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        //set image
        receiptImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        isFirstPhoto = 1
        
        //dismiss camera view
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        //dismiss camera view
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //MARK: Delegates
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
        tableView.reloadData()
    }
    
    func textViewDidChange(textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
        
        oneTime?.expenseDescription = textView.text
    }
    
    func dateAndTimeHasChanged(ChangedTo: NSDate, at: NSIndexPath) {
        oneTime?.date = ChangedTo
        tableView.reloadData()
    }
    
    func textInTextFieldHasChanged(ChangedTo: String, at: String) {
        if at == "Purpose" {
            oneTime?.name = ChangedTo
        } else if at == "Cost" {
            oneTime?.amount = (ChangedTo as NSString).doubleValue
        } else if at == "Location" {
            if !ChangedTo.isEmpty {
                oneTime?.location = ChangedTo
            }
        }
    }
    
    //reload Data
    override func viewDidAppear(animated: Bool) {
        if isFirstPhoto == 1 {
            tableView.reloadData()
        }
    }
    
    //MARK: Added Helper Functions
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