//
//  CustomTextField.swift
//  WAKEPARKBY
//
//  Created by Anjey Novicki on 7/8/20.
//  Copyright © 2020 Anjey Novicki. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {

    let border = CALayer()
    
    @IBInspectable var lineColor: UIColor = UIColor.lightGray {
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self;
        self.borderStyle = .none
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        border.backgroundColor = lineColor.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: lineHeight)
        border.cornerRadius = border.frame.height/2;
    }
    
}

// MARK: UITextFieldDelegate

extension CustomTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        border.backgroundColor = selectedLineColor.cgColor
        lineHeight = CGFloat(1.5)
        border.cornerRadius = border.frame.height/2;
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        border.backgroundColor = lineColor.cgColor
        lineHeight = CGFloat(1.0)
        border.cornerRadius = border.frame.height/2;
    }
}
