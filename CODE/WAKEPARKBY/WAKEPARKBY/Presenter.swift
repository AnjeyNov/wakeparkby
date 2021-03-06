//
//  Presenter.swift
//  WAKEPARKBY
//
//  Created by Anjey Novicki on 8/7/20.
//  Copyright © 2020 Anjey Novicki. All rights reserved.
//

import UIKit

class Presenter {
    static let shared = Presenter()
    
    private init(){}
}

extension Presenter {
    
    var rootViewController: UIViewController? {
        get {
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            return sceneDelegate?.window?.rootViewController
        }
        set {
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.window?.rootViewController = newValue
        }
    }
    
    func presentConfirmViewController(withParent parent: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ConfirmViewController") as! ConfirmViewController
        vc.previous = parent
        parent.present(vc, animated: true)
    }
    
    func presentMainMenu() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainMenu") as! UITabBarController
        rootViewController = vc
    }
    
    func presentAlert(_ title: String, _ message: String, _ viewController: UIViewController, callback: EmptyCallback? = nil) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in callback?() })
        
        dialogMessage.addAction(ok)
        viewController.present(dialogMessage, animated: true, completion: nil)
    }    
}
