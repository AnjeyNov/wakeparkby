//
//  RegistryViewController.swift
//  WAKEPARKBY
//
//  Created by Anjey Novicki on 7/13/20.
//  Copyright © 2020 Anjey Novicki. All rights reserved.
//

import UIKit

class RegistryViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var phoneNumberField: CustomTextField!
    @IBOutlet weak var nameField: CustomTextField!
    @IBOutlet weak var surnameField: CustomTextField!
    @IBOutlet weak var bdayField: CustomTextField!
    
    let datePicker = UIDatePicker()
    
// MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subscribe()
        let tapScreen = UITapGestureRecognizer(target: self,
                                               action: #selector(self.dismissKeyboard(sender:)))
        tapScreen.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapScreen)
        phoneNumberField.delegate = self
        nameField.delegate = self
        surnameField.delegate = self
        self.installDatePicker()
    }
    
    deinit {
        self.unSubscribe()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bottomConstraint.constant = (self.view.frame.height - self.stackView.frame.height)/2.0 - self.view.safeAreaInsets.bottom
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
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
           self.view.endEditing(true)
       }

    @objc func doneAction() {
        self.getDateFromPicker()
        self.view.endEditing(true)
    }
    
// MARK: - IBActions
    @IBAction func registerButtonTapped(_ sender: CustomButton) {
        self.view.endEditing(true)
        guard checkForm() else { return }
        guard let phoneNumber = self.phoneNumberField.text else { return }
        
        let successCallback = {
            DispatchQueue.main.async {
                self.phoneNumberField.border.backgroundColor = UIColor.red.cgColor
            }
        }
        let failreCallback = {
            isRegistered = false
            FirebaseManager.verufy(phoneNumber, self)
        }
        FirebaseManager.checkUser(phoneNumber, successCallback, failreCallback)
    }
    
}

// MARK: - Fileprivate methods
fileprivate extension RegistryViewController {
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
    
    func installDatePicker() {
        bdayField.delegate = self
        bdayField.inputView = self.datePicker
        datePicker.datePickerMode = .date
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        bdayField.inputAccessoryView = toolbar
    }
    
    func getDateFromPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        bdayField.text = formatter.string(from: datePicker.date)
    }
    
    func checkForm() -> Bool {
        var flag: Bool = false
        if phoneNumberField.text == "" {
            flag = true
            phoneNumberField.border.backgroundColor = UIColor.red.cgColor
        }
        if nameField.text == "" {
            flag = true
            nameField.border.backgroundColor = UIColor.red.cgColor
        }
        if surnameField.text == "" {
            flag = true
            surnameField.border.backgroundColor = UIColor.red.cgColor
        }
        if bdayField.text == "" {
            flag = true
            bdayField.border.backgroundColor = UIColor.red.cgColor
        }
        if flag { return false }
        return true
    }
        
}

// MARK: - UITextFieldDelegate
extension RegistryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != phoneNumberField { return true }
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "+XXX(XX)XXX-XX-XX", phone: newString)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneNumberField {
            let phoneNumber = phoneNumberField.text!
            let successCallback = {
                DispatchQueue.main.async {
                    self.phoneNumberField.border.backgroundColor = UIColor.red.cgColor
                }
            }
            FirebaseManager.checkUser(phoneNumber, successCallback)
        }
    }
}
