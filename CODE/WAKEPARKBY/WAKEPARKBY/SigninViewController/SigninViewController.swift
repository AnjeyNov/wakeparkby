//
//  SigninViewController.swift
//  WAKEPARKBY
//
//  Created by Anjey Novicki on 7/9/20.
//  Copyright © 2020 Anjey Novicki. All rights reserved.
//

import UIKit

class SigninViewController: UIViewController {

    @IBOutlet weak var numberField: CustomTextField!
    @IBOutlet weak var signinButton: CustomButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var substackView: UIStackView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Life Cycle
    deinit {
        self.unSubscribe()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subscribe()
        numberField.delegate = self
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(sender:)))
        tapScreen.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapScreen)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.bottomConstraint.constant = (self.view.frame.height - self.stackView.frame.height)/2.0 - self.view.safeAreaInsets.bottom
        self.stackView.setCustomSpacing(CGFloat(10.0), after: self.substackView)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
// MARK: - Public methods
    func showError(_ message: String) {
        self.numberField.border.backgroundColor = UIColor.red.cgColor
        self.errorLabel.text = message
        self.errorLabel.isHidden = false
        return
    }
    
// MARK: - IBactions
    @IBAction func signinButtonTapped(_ sender: CustomButton) {
        self.view.endEditing(true)
        
        guard let phoneNumber = self.numberField.text else { return }
        let successCallbak: EmptyCallback = {
            isRegistered = true
            FirebaseManager.verufy(phoneNumber, self)
        }
        let failureCallback: EmptyCallback = {
            DispatchQueue.main.async {
                self.showError("User does not exist")
            }
        }
        FirebaseManager.checkUser(phoneNumber, successCallbak, failureCallback)
    }
}

// MARK: - FilePrivate Methods
fileprivate extension SigninViewController {
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


// MARK: - UITextFieldDelegate
extension SigninViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "+XXX(XX)XXX-XX-XX", phone: newString)
        return false
    }
}

