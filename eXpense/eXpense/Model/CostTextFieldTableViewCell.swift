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
    var costString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        costTextField.delegate = self
        
        print(costString)
        
    }

    //Currency Formatting
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        switch string {
            
        case "0","1","2","3","4","5","6","7","8","9":
            costString += string
            formatCurrency(string: costString)
            
        default:
            var array = Array(string)
            var costStringArray = Array(costString)
            
            if array.count == 0 && costStringArray.count != 0 {
                costStringArray.removeLast()
                costString = ""
                
                for character in costStringArray {
                    costString += String(character)
                }
                
                formatCurrency(string: costString)
            }
        }
        
        return false
    }
    
    func formatCurrency(#string: String) {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        var numberFromField = (NSString(string: costString).doubleValue) / 100
        
        costTextField.text = formatter.stringFromNumber(numberFromField)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.textInTextFieldHasChanged(textField.text, at: "Cost")
        costTextField.resignFirstResponder()
        return true
    }
    
    func resignResponders() {
        if costTextField.isFirstResponder() {
            costTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.delegate?.updateFirstResponder(costTextField, identifier: "Cost_Begin")
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.delegate?.updateFirstResponder(costTextField, identifier: "Cost_End")
    }
}
