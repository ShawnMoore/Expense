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

class ReceiptViewController: UIViewController, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate {

    
    @IBOutlet weak var receiptScrollView: UIScrollView!
    
    //get receipt image
    var receiptImage:UIImage?
    
    //setup new camera
    var imagePicker: UIImagePickerController?
    var previousViewController: UIViewController?
    
    //initialize image view
    var receiptImageView = UIImageView()

    var minimumZoomScale:CGFloat = 1.0
    var maximumZoomScale:CGFloat = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //receiptScrollView.backgroundColor = UIColor.blackColor()
        receiptScrollView.userInteractionEnabled = true
        
        receiptScrollView.delegate = self
        receiptImageView.frame = CGRectMake(0, 0, receiptImage!.size.width, receiptImage!.size.height)
        
        receiptScrollView.contentSize = receiptImage!.size
        receiptScrollView.addSubview(receiptImageView)
        
        setUpScrollView()
        
    }
    
    func setUpScrollView() {
        receiptImageView.image = receiptImage
        receiptImageView.contentMode = UIViewContentMode.Center
        
        //let scrollViewFrame = receiptScrollView.frame
        let scaleWidth = receiptScrollView.frame.size.width / receiptScrollView.contentSize.width
        let scaleHeight = receiptScrollView.frame.size.height / receiptScrollView.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        
        receiptScrollView.minimumZoomScale = minScale
        receiptScrollView.maximumZoomScale = 1
        receiptScrollView.zoomScale = minScale
    }
    
    func centerScrollViewContents() {
        let boundsSize = receiptScrollView.bounds.size
        var contentsFrame = receiptImageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
        }
        else {
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
        }
        else {
            contentsFrame.origin.y = 0
        }
        
        receiptImageView.frame = contentsFrame
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return receiptImageView
    }
    
    override func viewDidLayoutSubviews() {
        initScale()
    }
    
    func initScale() {
        let scrollViewFrameSize = receiptScrollView.frame.size
        let imageSize = receiptImage!.size
        let scaleWidth = scrollViewFrameSize.width / imageSize.width
        let scaleHeight = scrollViewFrameSize.height / imageSize.height
        
        minimumZoomScale = min(scaleWidth, scaleHeight)
        
        receiptScrollView.minimumZoomScale = minimumZoomScale
        receiptScrollView.maximumZoomScale = maximumZoomScale
        
        //scrollView.zoomScale = minimumZoomScale
        receiptScrollView.setZoomScale(minimumZoomScale, animated: true)
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
