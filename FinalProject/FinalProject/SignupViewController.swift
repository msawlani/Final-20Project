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
        
       
    }
    
    @IBAction func Regi(_ sender: Any){
        
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
    
    @IBAction func ShowPassword(_ sender:Any){
        
        if showpasswordButton.titleLabel?.text == "Show"{
            passwordFieldText.isSecureTextEntry = false
            showpasswordButton.setTitle("Hide", for: .normal)
        }
        else{
            passwordFieldText.isSecureTextEntry = true
            showpasswordButton.setTitle("Show", for: .normal)
        }
    }
    
    @IBAction func ShowPassword2(_ sender:Any){
        
        if showpasswordButton2.titleLabel?.text == "Show"{
            reenterpasswordFieldText.isSecureTextEntry = false
            showpasswordButton2.setTitle("Hide", for: .normal)
        }
        else{
            reenterpasswordFieldText.isSecureTextEntry = true
            showpasswordButton2.setTitle("Show", for: .normal)
        }
    }
    
    @IBAction func PasswordHint(_ sender: Any) {
        let alert = UIAlertController(title: "Password Hint", message: "Password has to be 5 - 16 characters", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
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
