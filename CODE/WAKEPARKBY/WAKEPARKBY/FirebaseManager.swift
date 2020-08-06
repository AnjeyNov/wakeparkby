//
//  File.swift
//  WAKEPARKBY
//
//  Created by Anjey Novicki on 8/6/20.
//  Copyright © 2020 Anjey Novicki. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

typealias EmptyCallback = () -> ()

let db = Firestore.firestore()

class FirebaseManager {
    
    static func checkUser(_ phoneNumber: String, _ successfulCallback: @escaping EmptyCallback, _ failureCallback: EmptyCallback? = nil) {
        let docRef = db.collection("users").document(phoneNumber)
        docRef.getDocument { ( document, error) in
            if let document = document, document.exists {
                successfulCallback()
            } else if failureCallback != nil {
                failureCallback?()
            }
        }
    }
    
    static func verufy(_ phoneNumber: String, _ viewController: UIViewController) {
        Auth.auth().languageCode = "ru"
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            DispatchQueue.main.async {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                if error != nil {
                    let error = error! as NSError
                    switch error.code {
                    case AuthErrorCode.webContextCancelled.rawValue:
                        break
                    case AuthErrorCode.captchaCheckFailed.rawValue:
                        FirebaseManager.presentAlert("Error", error.localizedDescription, viewController)
                    case AuthErrorCode.networkError.rawValue:
                        FirebaseManager.presentAlert("Error", error.localizedDescription, viewController)
                    default:
                        if viewController is SigninViewController {
                            (viewController as! SigninViewController).showError("Incorrect number")
                        } else {
                            (viewController as! RegistryViewController).phoneNumberField.border.backgroundColor = UIColor.red.cgColor
                        }
                    }
                    return
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ConfirmViewController") as! ConfirmViewController
                vc.previous = viewController
                viewController.present(vc, animated: true)
            }
        }
    }
    
    static func auth(_ verificationCode: String, _ verificationID: String, _ viewController: ConfirmViewController) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                let error = error! as NSError
                switch error.code {
                case AuthErrorCode.invalidVerificationCode.rawValue:
                    self.presentAlert("Error", error.localizedDescription, viewController)
                case AuthErrorCode.networkError.rawValue:
                    self.presentAlert("Error", error.localizedDescription, viewController)
                default:
                    break
                }
                return
            }
            if !isRegistered {
                let previous = viewController.previous as! RegistryViewController
                user.name = previous.nameField.text!
                user.surname = previous.surnameField.text!
                user.phoneNumber = previous.phoneNumberField.text!
                user.bday = previous.bdayField.text!
                user.uid = authResult?.user.uid as! String
                FirebaseManager.addUser()
            } else {
                getUser((authResult?.user.phoneNumber)!)
            }
        }
    }
    
}

fileprivate extension FirebaseManager {
    
    static func presentAlert(_ title: String, _ message: String, _ viewController: UIViewController) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        dialogMessage.addAction(ok)
        viewController.present(dialogMessage, animated: true, completion: nil)
    }
    
    static func getDate(fromString string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.date(from:string)!
        return date
    }

    static func addUser() {
        do {
            let _ = try db.collection("users").document(user.phoneNumber).setData(from: user)
        }
        catch {
            print(error)
        }
    }
    
    static func getUser(_ phoneNumber: String) {
        let phoneNumber = format(with: "+XXX(XX)XXX-XX-XX", phone: phoneNumber)
        let docRef = db.collection("users").document(phoneNumber)
        docRef.getDocument() { (document, error) in
            let result = Result {
                try document?.data(as: Person.self)
            }
            switch result {
            case .success(let person):
                if let person = person {
                    user = person
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
