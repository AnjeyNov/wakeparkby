//
//  CustomTextField.swift
//  WAKEPARKBY
//
//  Created by Anjey Novicki on 7/8/20.
//  Copyright © 2020 Anjey Novicki. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    let border = CALayer()
    
    @IBInspectable var lineColor: UIColor = UIColor.gray {
        didSet {
            border.backgroundColor = lineColor.cgColor
        }
    }
    
    @IBInspectable var selectedLineColor : UIColor = UIColor.blue {
        didSet {
        }
    }

    @IBInspectable var lineHeight : CGFloat = CGFloat(1.0) {
        didSet {
            border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: lineHeight)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self;
        border.backgroundColor = lineColor.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: lineHeight)
        self.borderStyle = .none
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

}

// MARK: UITextFieldDelegate

extension CustomTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        border.backgroundColor = selectedLineColor.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        border.backgroundColor = lineColor.cgColor
    }
}
