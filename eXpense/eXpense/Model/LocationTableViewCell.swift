//
//  LocationTableViewCell.swift
//  eXpense
//
//  Created by Shawn Moore on 4/29/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    var delegate: TextFieldTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        locationTextField.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.textInTextFieldHasChanged("", at: "Location")
        locationTextField.resignFirstResponder()
        return true
    }
    
    func resignResponders() {
        if locationTextField.isFirstResponder() {
            locationTextField.resignFirstResponder()
        }
    }
}
