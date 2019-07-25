//
//  SettingsViewController.swift
//  FinalProject
//
//  Created by Michael Sawlani on 5/9/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class SettingsViewController: UIViewController {
    @IBOutlet weak var ChangeEmailAddress: UIButton!
    
    @IBOutlet weak var ChangePass: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if GIDSignIn.sharedInstance()?.currentUser == nil{
            ChangeEmailAddress.isEnabled = true
            ChangePass.isEnabled = true
        }else{
            ChangeEmailAddress.isEnabled = false
            ChangePass.isEnabled = false
        }
        

//        //Example income
//        let tempIncome = Transaction()
//        tempIncome.amount = 100
//        tempIncome.category = mainUser.categories[3]
//        mainUser.accounts[0].AddTransaction(transaction: tempIncome)
//
//        let tempExpense = Transaction()
//        tempExpense.amount = -40
//        tempExpense.category = mainUser.categories[4]
//        mainUser.accounts[0].AddTransaction(transaction: tempExpense)
//        //Justin 
    }
    @IBAction func Logout(_ sender: Any) {
            let alert = UIAlertController(title: "Logging Out? ", message: "Are you Sure you Want to Logout?", preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))

        
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
                do{
                    try Auth.auth().signOut()
                    GIDSignIn.sharedInstance()?.signOut()
                }catch let Logouterror{
                    print(Logouterror)
                }
                self.performSegue(withIdentifier: "Login", sender: self)
                
            }))
            
        
            self.present(alert, animated: true)
        
    }
    @IBAction func ChangeEmail(_ sender: Any) {
    }
    @IBAction func ChangePass(_ sender: Any) {
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
