//
//  ChangeEmailViewController.swift
//  FinalProject
//
//  Created by Michael Sawlani on 5/23/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ChangeEmailViewController: UIViewController {
    @IBOutlet weak var emailFieldText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ChangeEmail(_ sender: Any) {
        guard let email = emailFieldText.text else {return}
        
        Auth.auth().currentUser?.updateEmail(to: email) { error in
            if let error = error{
                print(error)
                
                let emailAlert = UIAlertController(title: "Failed to Change Email!", message: "Must enter email!", preferredStyle: .alert)
                
                emailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(emailAlert, animated: true)
            }
            else{
                let message = "You can now re-login as: " + email
                let alert = UIAlertController(title: "Successful Change to Email", message: message, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action) in
                    do{
                        try Auth.auth().signOut()
                        self.performSegue(withIdentifier: "Login", sender: self)
                    }catch let Logouterror{
                        print(Logouterror)
                    }
            }))
                
                self.present(alert, animated: true)
            }
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
}
