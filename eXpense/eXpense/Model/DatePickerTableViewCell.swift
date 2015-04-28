//
//  DatePickerTableViewCell.swift
//  eXpense
//
//  Created by Megan Ritchey on 4/26/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

protocol DatePickerTableViewCellDelegate : class {
    func dateAndTimeHasChanged(ChangedTo: NSDate, at: NSIndexPath);
}

class DatePickerTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate: DatePickerTableViewCellDelegate?
    var location: NSIndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func dateChanged(sender: AnyObject) {
        self.delegate?.dateAndTimeHasChanged(datePicker!.date, at: location!)
    }
}
