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

    let emailFieldText = UITextField(frame: CGRect(x: 10, y: 100, width: UIScreen.main.bounds.size.width - 32, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailFieldText.backgroundColor = .white
        emailFieldText.borderStyle = .line
        emailFieldText.keyboardAppearance = .dark
        emailFieldText.keyboardType = .emailAddress
        emailFieldText.autocapitalizationType = .none
        emailFieldText.placeholder = "email..."
        view.addSubview(emailFieldText)
        
        let resetButton = UIButton(frame: CGRect(x: 10, y: 160, width: view.frame.width - 32, height: 50))
        resetButton.setTitle("Reset", for: .normal)
        resetButton.backgroundColor = .black
        resetButton.tintColor = .white
        resetButton.addTarget(self, action: #selector(Reset(_:)), for: .touchUpInside)
        view.addSubview(resetButton)
        // Do any additional setup after loading the view.
    }
    
    @objc public func Reset(_ :UIButton){
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
}
