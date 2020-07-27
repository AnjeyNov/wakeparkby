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
    //override var delegate: UITextFieldDelegate?
    
    @IBInspectable var lineColor: UIColor = UIColor.lightGray {
        didSet {
            border.backgroundColor = lineColor.cgColor
        }
    }
    
    @IBInspectable var selectedLineColor : UIColor = UIColor.blue

    @IBInspectable var lineHeight : CGFloat = CGFloat(1.0) {
        didSet {
            border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: lineHeight)
        }
    }
    
    deinit {
        self.unSubscribe()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.borderStyle = .none
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.subscribe()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        border.backgroundColor = lineColor.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: lineHeight)
        border.cornerRadius = border.frame.height/2;
    }
    
    @objc func didBeginEditing() {
        border.backgroundColor = selectedLineColor.cgColor
        lineHeight = CGFloat(1.5)
        border.cornerRadius = border.frame.height/2;
    }
    
    @objc func didEndEditing() {
        border.backgroundColor = lineColor.cgColor
        lineHeight = CGFloat(1.0)
        border.cornerRadius = border.frame.height/2;
    }
    
}

// MARK: Private mothods
fileprivate extension CustomTextField {
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didBeginEditing),
                                               name: UITextField.textDidBeginEditingNotification,
                                               object: self)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didEndEditing),
                                               name: UITextField.textDidEndEditingNotification,
                                               object: self)
    }
    
    func unSubscribe() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UITextField.textDidBeginEditingNotification,
                                                  object: self)
        
        NotificationCenter.default.removeObserver(self,
                                                 name: UITextField.textDidEndEditingNotification,
                                                 object: self)
    }
}
