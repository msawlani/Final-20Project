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
    var balance = 0
    
    @IBOutlet weak var balanceText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let ref = Database.database().reference()
        
        databaseHandle = ref.child("user1").child("account").observe(.childChanged, with: { (snapshot) in
            
            //Convert the info of the data into a string variable
            //let getData = snapshot.value as? String
            //print(getData)
            
            let amount = snapshot.value as? String
            var balanceString = "Balance: "
            balanceString.append(amount!)
            self.balanceText.text = balanceString
        })
        
        ref.child("user1").child("username").setValue("user1")
        ref.child("user1").child("account").child("accountName").setValue("account1")
        ref.child("user1").child("account").child("balance").setValue(String(balance))
        
        var user2 = User(username: "testUser2")
        var account1 = Account(name: "testAccount1", balance: 589.0)
        user2.AddAccount(account: account1)
        
        user2.StoreInFirebase()

    }
    
    @IBAction func addToBalance(_ sender: Any) {
        let ref = Database.database().reference()
        self.balance = balance + 100
        ref.child("user1").child("account").child("balance").setValue(String(balance))
    }
}

