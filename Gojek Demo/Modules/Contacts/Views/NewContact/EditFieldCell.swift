//
//  EditFieldCell.swift
//  Gojek Demo
//
//  Created by Hemant Singh on 08/08/19.
//  Copyright © 2019 Hemant. All rights reserved.
//

import UIKit

class EditFieldCell: UITableViewCell {
  static let reuseIdentifier = "EditFieldCell"
  var index = 0
  var completionCallback: ((Int, String) -> Void)?
    @IBOutlet weak var textField: TVTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension EditFieldCell:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch index {
        case 0,1:
            textField.keyboardType = .default
        case 2:
            textField.keyboardType = .numbersAndPunctuation
        case 3:
            textField.keyboardType = .emailAddress
        default:
            break
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text{
            completionCallback?(index, text)
        }
    }
}
