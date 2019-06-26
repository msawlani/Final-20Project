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
    
    
    @IBOutlet weak var emailFieldText: UITextField!
    
    @IBOutlet weak var passwordFieldText: UITextField!
    
    @IBOutlet weak var reenterpasswordFieldText: UITextField!
    
    @IBOutlet weak var showpasswordButton: UIButton!
    
    @IBOutlet weak var showpasswordButton2: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignupViewController.back(sender:)))
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
    //registers the user with firebase  and checks for errors - Michael Sawlani
    @IBAction func Regi(_ sender: Any){
        
        guard let email = emailFieldText.text else {return}
        guard let password = passwordFieldText.text else {return}
        
        //creates the user using firebase - Michael Sawlani
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
    
    //shows and hides the password that user enters - Michael Sawlani
    @IBAction func ShowPassword(_ sender:Any){
        
        if showpasswordButton.titleLabel?.text == "Show"{
            passwordFieldText.isSecureTextEntry = false
            reenterpasswordFieldText.isSecureTextEntry = false
            showpasswordButton.setTitle("Hide", for: .normal)
            showpasswordButton2.setTitle("Hide", for: .normal)

        }
        else{
            passwordFieldText.isSecureTextEntry = true
            showpasswordButton.setTitle("Show", for: .normal)
            reenterpasswordFieldText.isSecureTextEntry = true
            showpasswordButton2.setTitle("Show", for: .normal)
        }
    }
    
    //shows and hides the password that user enters - Michael Sawlani
    @IBAction func ShowPassword2(_ sender:Any){
        
        if showpasswordButton2.titleLabel?.text == "Show"{
            reenterpasswordFieldText.isSecureTextEntry = false
            passwordFieldText.isSecureTextEntry = false
            showpasswordButton2.setTitle("Hide", for: .normal)
            showpasswordButton.setTitle("Hide", for: .normal)

        }
        else{
            reenterpasswordFieldText.isSecureTextEntry = true
            showpasswordButton2.setTitle("Show", for: .normal)
            passwordFieldText.isSecureTextEntry = true
            showpasswordButton.setTitle("Show", for: .normal)
        }
    }
    
    //shows the recommended passwowrd length - Michael Sawlani
    @IBAction func PasswordHint(_ sender: Any) {
        let alert = UIAlertController(title: "Password Hint", message: "Password has to be 8 - 16 characters", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    @IBAction func Back(_ sender: Any) {
        self.performSegue(withIdentifier: "Login", sender: self)
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
