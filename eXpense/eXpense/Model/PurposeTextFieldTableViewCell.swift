//
//  PurposeTextFieldTableViewCell.swift
//  eXpense
//
//  Created by Shawn Moore on 4/29/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class PurposeTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var purposeTextField: UITextField!
    var delegate: TextFieldTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        purposeTextField.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.textInTextFieldHasChanged("", at: "Purpose")
        purposeTextField.resignFirstResponder()
        return true
    }
    
    func resignResponders() {
        if purposeTextField.isFirstResponder() {
            purposeTextField.resignFirstResponder()
        }
    }
    

}
