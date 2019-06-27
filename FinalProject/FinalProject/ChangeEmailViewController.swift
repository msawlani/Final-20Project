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
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ChangeEmailViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        newBackButton.tintColor = UIColor.white
    }
    @objc func back(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Are You Sure?", message: "If You Proceed, All Data On This Page Will Be Lost", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        
        self.present(alertController, animated: true)
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

}
    @IBAction func Back(_ sender: Any) {
        self.performSegue(withIdentifier: "Back", sender: self)
    }
}
