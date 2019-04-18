//
//  SecondViewController.swift
//  FinalProject
//
//  Created by Victor  Perez on 4/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import Firebase

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let ref = Database.database().reference()
        
        ref.child("user1").child("username").setValue("user1")
        ref.child("user1").child("account").child("accountName").setValue("account1")
        ref.child("user1").child("account").child("balance").setValue(999)
        
        
    }


}

