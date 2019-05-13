//
//  SignupViewController.swift
//  FinalProject
//
//  Created by Michael Sawlani on 5/6/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {

    let emailFieldText = UITextField(frame: CGRect(x: 10, y: 100, width: UIScreen.main.bounds.size.width - 32, height: 50))
    let passwordFieldText = UITextField(frame: CGRect(x: 10, y: 160, width: UIScreen.main.bounds.size.width - 32, height: 50))
    let reenterpasswordFieldText = UITextField(frame: CGRect(x: 10, y: 220, width: UIScreen.main.bounds.size.width - 32, height: 50))

    let showpasswordButton = UIButton(frame: CGRect(x: 326, y: 165, width: 60, height: 40))
    
    let showpasswordButton2 = UIButton(frame: CGRect(x: 326, y: 226, width: 60, height: 40))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        emailFieldText.backgroundColor = .white
        emailFieldText.borderStyle = .line
        emailFieldText.keyboardAppearance = .dark
        emailFieldText.keyboardType = .emailAddress
        emailFieldText.autocapitalizationType = .none
        emailFieldText.placeholder = "email..."
        view.addSubview(emailFieldText)
        
        passwordFieldText.backgroundColor = .white
        passwordFieldText.borderStyle = .line
        passwordFieldText.keyboardAppearance = .dark
        passwordFieldText.keyboardType = .default
        passwordFieldText.isSecureTextEntry = true
        passwordFieldText.placeholder = "password..."
        view.addSubview(passwordFieldText)
        
        reenterpasswordFieldText.backgroundColor = .white
        reenterpasswordFieldText.borderStyle = .line
        reenterpasswordFieldText.keyboardAppearance = .dark
        reenterpasswordFieldText.keyboardType = .default
        reenterpasswordFieldText.isSecureTextEntry = true
        reenterpasswordFieldText.placeholder = "reenterpassword..."
        view.addSubview(reenterpasswordFieldText)
        
        showpasswordButton.setTitle("Show", for: .normal)
        showpasswordButton.backgroundColor = .black
        showpasswordButton.tintColor = .white
        showpasswordButton.addTarget(self, action: #selector(ShowPassword(_:)), for: .touchUpInside)
        view.addSubview(showpasswordButton)
        
        showpasswordButton2.setTitle("Show", for: .normal)
        showpasswordButton2.backgroundColor = .black
        showpasswordButton2.tintColor = .white
        showpasswordButton2.addTarget(self, action: #selector(ShowPassword2(_:)), for: .touchUpInside)
        view.addSubview(showpasswordButton2)

        let signupButton = UIButton.init(frame: CGRect(x: 10, y: 280, width: view.frame.width - 32, height: 50))
        signupButton.setTitle("Register", for: .normal)
        signupButton.backgroundColor = .black
        signupButton.tintColor = .white
        signupButton.addTarget(self, action: #selector(Regi(_:)), for: .touchUpInside)
        view.addSubview(signupButton)

        // Do any additional setup after loading the view.
    }
    
    @objc public func Regi(_ :UIButton){
        
        guard let email = emailFieldText.text else {return}
        guard let password = passwordFieldText.text else {return}
        
        //creates the user using firebase
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if  error == nil && user != nil && self.emailFieldText.text != nil &&
                self.passwordFieldText.text == self.reenterpasswordFieldText.text
            {
        
                let alert = UIAlertController(title: "Register Successful", message: "Successfully made an Account with Firebase", preferredStyle: .alert)
        
                
                let regiAction = UIAlertAction(title: "OK", style: .default) { [unowned self] action in
                            self.performSegue(withIdentifier: "Main", sender: self)
                    
                }
                alert.addAction(regiAction)
                self.present(alert, animated: true)
                
                
            }
            else if self.passwordFieldText.text != self.reenterpasswordFieldText.text{
                let alert = UIAlertController(title: "Failed to Register User", message: "Passwords Don't Match!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }else{
                let alert = UIAlertController(title: "Failed to Register User", message: "Please Fill out the Information Needed", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)

            

            }
        }
    
        

    }

    @objc public func ShowPassword(_ :UIButton){
        
        if showpasswordButton.titleLabel?.text == "Show"{
            passwordFieldText.isSecureTextEntry = false
            showpasswordButton.setTitle("Hide", for: .normal)
        }
        else{
            passwordFieldText.isSecureTextEntry = true
            showpasswordButton.setTitle("Show", for: .normal)
        }
    }
    
    @objc public func ShowPassword2(_ :UIButton){
        
        if showpasswordButton2.titleLabel?.text == "Show"{
            reenterpasswordFieldText.isSecureTextEntry = false
            showpasswordButton2.setTitle("Hide", for: .normal)
        }
        else{
            reenterpasswordFieldText.isSecureTextEntry = true
            showpasswordButton2.setTitle("Show", for: .normal)
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
