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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(sender:)))
        tapScreen.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapScreen)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func signinButtonTapped(_ sender: CustomButton) {
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
