//
//  RegistryViewController.swift
//  WAKEPARKBY
//
//  Created by Anjey Novicki on 7/13/20.
//  Copyright © 2020 Anjey Novicki. All rights reserved.
//

import UIKit

class RegistryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(sender:)))
        tapScreen.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapScreen)
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
           self.view.endEditing(true)
       }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
