//
//  AccountViewController.swift
//  WAKEPARKBY
//
//  Created by Anjey Novicki on 8/15/20.
//  Copyright © 2020 Anjey Novicki. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var bdayLabel: UILabel!
    @IBOutlet weak var subscriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameLabel.text = user.name
        surnameLabel.text = user.surname
        phoneLabel.text = user.phoneNumber
        bdayLabel.text = user.bday
        subscriptionLabel.text = String(user.subscription)
    }
    
}
