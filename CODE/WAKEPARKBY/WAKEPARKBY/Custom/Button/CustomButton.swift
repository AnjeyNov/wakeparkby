//
//  CustomButton.swift
//  WAKEPARKBY
//
//  Created by Anjey Novicki on 7/10/20.
//  Copyright © 2020 Anjey Novicki. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {

    @IBInspectable
    var borderWidth: CGFloat = CGFloat(1.0) {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = CGFloat(1.0) {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var borderColor = UIColor.black {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        cornerRadius = self.frame.height/2
    }
    

}
