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
    

    @IBOutlet var emailFieldText: UITextField!
    @IBOutlet var passwordFieldText: UITextField!
    
    @IBOutlet weak var showPasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
//logs the user in on pressed using the firebase account - Michael Sawlani
    @IBAction func Login(_ sender: Any) {
        guard let email = emailFieldText.text else {return}
        guard let password = passwordFieldText.text else {return}
        
        
        Auth.auth().signIn(withEmail: email, password: password) {user, error in
            if error == nil && user != nil && self.passwordFieldText.text != nil
            {
                mainUser.userId = Auth.auth().currentUser!.uid
                userEmail = email
                signedInWithGoogle = false

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
    
    //takes the user to signup page on pressed - Michael Sawlani
    @IBAction func Signup(_ sender: Any) {
        performSegue(withIdentifier: "Signup", sender: self)
    }
    
    //takes the user to fogot password on pressed - Michael Sawlani
    @IBAction func ForgotPassword(_ sender: Any) {
         performSegue(withIdentifier: "ForgotPass", sender: self)
    }
    
    //shows and hides the password on pressed - Michael Sawlani
    @IBAction func ShowPassword(_ sender: Any) {
        if showPasswordButton.titleLabel?.text == "Show"{
            passwordFieldText.isSecureTextEntry = false
            showPasswordButton.setTitle("Hide", for: .normal)
        }
        else{
            passwordFieldText.isSecureTextEntry = true
            showPasswordButton.setTitle("Show", for: .normal)
        }
    }
    
    
    @IBAction func PasswordHint(_ sender: Any) {
        let alert = UIAlertController(title: "Password Hint", message: "Password has to be 8 - 16 characters", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    @IBAction func Back(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "loginView") as? LogInView else {
            return
        }
        
        
        //self.push(viewController, animated: false, completion: nil)
        self.navigationController?.pushViewController(viewController, animated: true)

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
