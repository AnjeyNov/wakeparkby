//
//  ConfirmViewController.swift
//  WAKEPARKBY
//
//  Created by Anjey Novicki on 7/27/20.
//  Copyright © 2020 Anjey Novicki. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var codeField: CustomTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var confirmButton: CustomButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    weak var previous: UIViewController?
    
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    
// MARK: - Life cycle
    deinit {
        self.unSubscribe()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subscribe()
        self.codeField.delegate = self
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(sender:)))
        tapScreen.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapScreen)
        self.bottomConstraint.constant = (self.view.frame.height - self.stackView.frame.height)/2.0 - self.view.safeAreaInsets.bottom
        self.stackView.setCustomSpacing(CGFloat(10.0), after: self.codeField)
    }
    

    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let rect = (notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        let bottom = rect.height + 10.0
        if bottom > (bottomConstraint.constant + self.view.safeAreaInsets.bottom) {
            bottomConstraint.constant = bottom
            let duration: Double = (notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! NSNumber).doubleValue
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = (self.view.frame.height - self.stackView.frame.height)/2.0 - self.view.safeAreaInsets.bottom
        let duration: Double = (notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! NSNumber).doubleValue
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
// MARK: - IBActions
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.codeField.text == "" {
            self.codeField.border.backgroundColor = UIColor.red.cgColor
            self.errorLabel.text = "Input code"
            self.errorLabel.isHidden = false
        }
        let verificationCode = codeField.text!
        FirebaseManager.auth(verificationCode, verificationID!, self)
    }
}

// MARK: - FilePrivate Methods
fileprivate extension ConfirmViewController {
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
       
    
    func unSubscribe() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
}

// MARK: -UITextFieldDelegate
extension ConfirmViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
