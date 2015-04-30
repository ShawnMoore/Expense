//
//  CostTextFieldTableViewCell.swift
//  eXpense
//
//  Created by Shawn Moore on 4/29/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

class CostTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var costTextField: UITextField!
    var delegate: TextFieldTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        costTextField.delegate = self
        costTextField.placeholder = "Cost"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.textInTextFieldHasChanged("", at: "Cost")
        costTextField.resignFirstResponder()
        return true
    }
    
    func resignResponders() {
        if costTextField.isFirstResponder() {
            costTextField.resignFirstResponder()
        }
    }
}
