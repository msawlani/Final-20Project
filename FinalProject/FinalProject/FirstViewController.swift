//
//  FirstViewController.swift
//  FinalProject
//
//  Created by Victor  Perez on 4/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController {
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    @IBOutlet weak var balanceText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let ref = Database.database().reference()
        
        databaseHandle = ref.child("user1").child("account").observe(.childChanged, with: { (snapshot) in
            
            //Convert the info of the data into a string variable
            //let getData = snapshot.value as? String
            //print(getData)
            
            let balance = snapshot.value as? String
            var balanceString = "Balance: "
            balanceString.append(balance!)
            self.balanceText.text = balanceString
        })
        
        ref.child("user1").child("username").setValue("user1")
        ref.child("user1").child("account").child("accountName").setValue("account1")
        ref.child("user1").child("account").child("balance").setValue("999")


    }
}

