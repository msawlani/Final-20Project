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
    }
    @IBAction func Logout(_ sender: Any) {
        do{
            try
                Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
        }catch let logouterror{
            print(logouterror)
        }
        self.performSegue(withIdentifier: "Login", sender: self)
        
    }
    @IBAction func ChangeEmail(_ sender: Any) {
        self.performSegue(withIdentifier: "ChangeEmail", sender: self)
    }
    @IBAction func ChangePass(_ sender: Any) {
        self.performSegue(withIdentifier: "ChangePass", sender: self)
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
