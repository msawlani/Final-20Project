//
//  LoginViewController.swift
//  FinalProject
//
//  Created by Michael Sawlani on 5/6/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit

class UserLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let emailFieldText = UITextField(frame: CGRect(x: 10, y: 100, width: UIScreen.main.bounds.size.width - 32, height: 50))
        emailFieldText.backgroundColor = .white
        emailFieldText.borderStyle = .line
        emailFieldText.keyboardAppearance = .dark
        emailFieldText.keyboardType = .emailAddress
        emailFieldText.placeholder = "email..."
        view.addSubview(emailFieldText)
        
        let passwordFieldText = UITextField(frame: CGRect(x: 10, y: 160, width: UIScreen.main.bounds.size.width - 32, height: 50))
        passwordFieldText.backgroundColor = .white
        passwordFieldText.borderStyle = .line
        passwordFieldText.keyboardAppearance = .dark
        passwordFieldText.keyboardType = .default
        passwordFieldText.isSecureTextEntry = true
        passwordFieldText.placeholder = "password..."
        view.addSubview(passwordFieldText)
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
