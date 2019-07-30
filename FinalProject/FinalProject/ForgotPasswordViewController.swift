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

        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "<", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ForgotPasswordViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        newBackButton.tintColor = UIColor.white
        let systemFontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)]
        newBackButton.setTitleTextAttributes(systemFontAttributes, for: .normal)
    }
    @objc func back(sender: UIBarButtonItem) {
        
        if emailFieldText.text?.isEmpty != true{
        let alertController = UIAlertController(title: "Are You Sure?", message: "If You Proceed, All Data On This Page Will Be Lost", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        
        self.present(alertController, animated: true)
        }else{
        self.navigationController?.popViewController(animated: true)
        }
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
