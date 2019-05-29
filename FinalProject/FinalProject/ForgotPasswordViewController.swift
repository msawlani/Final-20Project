//
//  ForgotPasswordViewController.swift
//  FinalProject
//
//  Created by Michael Sawlani on 5/8/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailFieldText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func Reset(_ sender:Any){
        guard let email = emailFieldText.text else {return}
        Auth.auth().sendPasswordReset(withEmail: email) {error in
            if let error = error{
                print(error)
                let alert = UIAlertController(title: "Failed to Send Link", message: "Must enter email", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }else{
                let message = "Check Email: " + email
                let alert = UIAlertController(title: "Successful Sending Link", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action) in                self.performSegue(withIdentifier: "Login", sender: self)
                    
                }))
                self.present(alert, animated: true)

            }
        }

    }
    @IBAction func Back(_ sender: Any) {
        self.performSegue(withIdentifier: "Login", sender: self)
    }
    
    
}
