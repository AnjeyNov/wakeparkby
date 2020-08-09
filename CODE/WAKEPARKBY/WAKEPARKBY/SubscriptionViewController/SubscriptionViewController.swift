//
//  SubscriptionViewController.swift
//  WAKEPARKBY
//
//  Created by Anjey Novicki on 8/9/20.
//  Copyright © 2020 Anjey Novicki. All rights reserved.
//

import UIKit

class SubscriptionViewController: UIViewController {
    @IBOutlet weak var balanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user.subscription > 0 {
            balanceLabel.text = "Your balance: " + String(user.subscription)
        } else {
            balanceLabel.text = "You haven't subscription"
        }
        // Do any additional setup after loading the view.
    }
    

}
