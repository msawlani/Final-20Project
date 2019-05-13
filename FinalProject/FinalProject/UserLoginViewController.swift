//
//  LoginViewController.swift
//  FinalProject
//
//  Created by Michael Sawlani on 5/6/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserLoginViewController: UIViewController {

    let emailFieldText = UITextField(frame: CGRect(x: 10, y: 100, width: UIScreen.main.bounds.size.width - 32, height: 50))

    let passwordFieldText = UITextField(frame: CGRect(x: 10, y: 160, width: UIScreen.main.bounds.size.width - 32, height: 50))
    
    let showpasswordButton = UIButton(frame: CGRect(x: 326, y: 165, width: 60, height: 40))


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
        
        let loginButton = UIButton(frame: CGRect(x: 10, y: 250, width: view.frame.width - 32, height: 50))
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .black
        loginButton.tintColor = .white
        loginButton.addTarget(self, action: #selector(Login(_:)), for: .touchUpInside)
        view.addSubview(loginButton)
        
        showpasswordButton.setTitle("Show", for: .normal)
        showpasswordButton.backgroundColor = .black
        showpasswordButton.tintColor = .white
        showpasswordButton.addTarget(self, action: #selector(ShowPassword(_:)), for: .touchUpInside)
        view.addSubview(showpasswordButton)
        
        let signupButton = UIButton(frame: CGRect(x: 10, y: 310, width: view.frame.width - 32, height: 50))
        signupButton.setTitle("Signup", for: .normal)
        signupButton.backgroundColor = .black
        signupButton.tintColor = .white
        signupButton.addTarget(self, action: #selector(Signup(_:)), for: .touchUpInside)
        view.addSubview(signupButton)
        
        let forgotpasswordButton = UIButton(frame: CGRect(x: 10, y: 370, width: view.frame.width - 32, height: 50))
        forgotpasswordButton.setTitle("Forgot Password?", for: .normal)
        forgotpasswordButton.backgroundColor = .black
        forgotpasswordButton.tintColor = .white
        forgotpasswordButton.addTarget(self, action: #selector(ForgotPassword(_:)), for: .touchUpInside)
        view.addSubview(forgotpasswordButton)
    }
    
    @objc public func Login(_ :UIButton){
        guard let email = emailFieldText.text else {return}
        guard let password = passwordFieldText.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) {user, error in
            if error == nil && user != nil && self.passwordFieldText.text != nil
            {
                self.performSegue(withIdentifier: "Main", sender: self)
            }
            else if self.passwordFieldText.text == nil{
                let alert = UIAlertController(title: "Failed to Login", message: "Please Enter Password", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
            else{
                let alert = UIAlertController(title: "Failed to Login", message: "Email and/or password is incorrect", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
            

        }
        
    }
    
    @objc public func Signup(_ :UIButton){
        performSegue(withIdentifier: "Signup", sender: self)
    }
    
    @objc public func ForgotPassword(_ :UIButton){
        performSegue(withIdentifier: "ForgotPass", sender: self)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
