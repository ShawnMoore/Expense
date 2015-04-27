//
//  ReceiptViewController.swift
//  eXpense
//
//  Created by Randall Lee Schilling on 4/26/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class ReceiptViewController: UIViewController, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    var receiptImage:UIImage?
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    var imagePicker: UIImagePickerController!
    var previousViewController: UIViewController?
    
    @IBOutlet weak var receiptImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiptImageView.image = receiptImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retakePhoto(sender: AnyObject) {
        //camera detected
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            var picker = UIImagePickerController()
            picker.delegate = self
            //picker.delegate = self
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        print(mediaType)
        
        //set image
        receiptImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        (previousViewController as! NewOneTimeExpenseTableViewController).receiptImage = receiptImage
        //set current view to updated image
        receiptImageView.image = receiptImage
        
        //dismiss camera view
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
