//
//  TextFieldTableViewCell.swift
//  eXpense
//
//  Created by Megan Ritchey on 4/26/15.
//  Copyright (c) 2015 BoardPaq LLC. All rights reserved.
//

import UIKit

protocol TextFieldTableViewCellDelegate : class {
    func textInTextFieldHasChanged(ChangedTo: String, at: String)
    func updateFirstResponder(identifier: String)
}

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var cellTextField: UITextField!
    var delegate: TextFieldTableViewCellDelegate?
    var identifier: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellTextField.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func textFieldHasChanged(sender: AnyObject) {
        self.delegate?.textInTextFieldHasChanged(cellTextField.text, at: identifier!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.textInTextFieldHasChanged(cellTextField.text, at: identifier!)
        cellTextField.resignFirstResponder()
        return true
    }
    
    func resignResponders() {
        if cellTextField.isFirstResponder() {
            cellTextField.resignFirstResponder()
        }
    }
}
