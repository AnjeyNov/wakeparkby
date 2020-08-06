//
//  ConfirmViewController.swift
//  WAKEPARKBY
//
//  Created by Anjey Novicki on 7/27/20.
//  Copyright © 2020 Anjey Novicki. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConfirmViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var codeField: CustomTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var confirmButton: CustomButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    weak var previous: UIViewController?
    
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    
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
    

    // MARK: Public Methods
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
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.codeField.text == "" {
            self.codeField.border.backgroundColor = UIColor.red.cgColor
            self.errorLabel.text = "Input code"
            self.errorLabel.isHidden = false
        }
        let verificationCode = codeField.text!
        self.auth(verificationCode)
        
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
    
    func auth(_ verificationCode: String) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                let error = error! as NSError
                switch error.code {
                case AuthErrorCode.invalidVerificationCode.rawValue:
                    self.presentAlert("Error", error.localizedDescription)
                case AuthErrorCode.networkError.rawValue:
                    self.presentAlert("Error", error.localizedDescription)
                default:
                    break
                }
                return
            }
            if !isRegistered {
                let previous = self.previous as! RegistryViewController
                user.name = previous.nameField.text!
                user.surname = previous.surnameField.text!
                user.phoneNumber = previous.phoneNumberField.text!
                user.bday = previous.bdayField.text!
            }
        }
    }
    
    func presentAlert(_ title: String, _ message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

// MARK: -UITextFieldDelegate
extension ConfirmViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
