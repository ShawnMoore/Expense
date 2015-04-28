//
//  NewOneTimeExpenseTableViewController.swift
//  eXpense
//
//  Created by Randall Lee Schilling on 3/13/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class NewOneTimeExpenseTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var receiptLabel: UILabel!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var recieptPhotoButton: UIButton!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var receiptImageView: UIImageView!
    
    var receiptImage:UIImage?
    var isFirstPhoto = 0
    var imagePicker: UIImagePickerController!
    
    let pickerData = ["Entertainment","Lodging","Meals","Personal","Transportation","Other"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        categoryPicker.selectRow(2, inComponent: 0, animated: false)
        
        receiptImageView.contentMode = .ScaleAspectFit
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        descriptionView.layer.cornerRadius = 5
        descriptionView.layer.borderColor = UIColor.grayColor().CGColor
        descriptionView.layer.borderWidth = 0.2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func appendDollarSign(sender: AnyObject) {
        var userCost = costTextField.text
        let array = Array(userCost)
        if array[0] != "$" {
            costTextField.text = "$" + userCost

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showReceipt" {
            let destViewController = segue.destinationViewController as! ReceiptViewController
            destViewController.receiptImage = receiptImage
            destViewController.previousViewController = self
            navigationItem.title = nil
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        //set image
        receiptImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        receiptImageView.image = receiptImage
        recieptPhotoButton.setTitle("", forState: UIControlState.Normal)
        isFirstPhoto = 1
        
        //dismiss camera view
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }

    override func viewDidAppear(animated: Bool) {
        navigationItem.title = "New Expense"
        if receiptImage != nil {
            receiptImageView.image = receiptImage
        }
    }
    
    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
