//
//  ChangePassViewController.swift
//  FinalProject
//
//  Created by Michael Sawlani on 5/23/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChangePassViewController: UIViewController {
    
    @IBOutlet weak var passwordFieldText: UITextField!
    @IBOutlet weak var reenterpasswordFieldText: UITextField!
    @IBOutlet weak var showPassword1: UIButton!
    @IBOutlet weak var showPassword2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ChangePassViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        newBackButton.tintColor = UIColor.white
    }
    @objc func back(sender: UIBarButtonItem) {
        if passwordFieldText.text?.isEmpty != true && reenterpasswordFieldText.text?.isEmpty != true{
        let alertController = UIAlertController(title: "Are You Sure?", message: "If You Proceed, All Data On This Page Will Be Lost", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        
        self.present(alertController, animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func ChangPass(_ sender: Any) {
        guard let password = passwordFieldText.text else {
            return
        }
        
        Auth.auth().currentUser?.updatePassword(to: password) { error in
            if let error = error{
                print(error)
                let alert = UIAlertController(title: "Failed to Change Password", message: "Passwords must match!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }else{
                let message = "You can now re-login with your new password"
                let alert = UIAlertController(title: "Successful Change to Password", message: message, preferredStyle: .alert)
                
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
    
    @IBAction func PasswordHint(_ sender: Any) {
        let alert = UIAlertController(title: "Password Hint", message: "Password much be 8 to 16 characters", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func ShowPassword1(_ sender: Any) {
        if showPassword1.titleLabel?.text == "Show"{
            passwordFieldText.isSecureTextEntry = false
            reenterpasswordFieldText.isSecureTextEntry = false
            showPassword1.setTitle("Hide", for: .normal)
            showPassword2.setTitle("Hide", for: .normal)
            
        }
        else{
            passwordFieldText.isSecureTextEntry = true
            showPassword1.setTitle("Show", for: .normal)
            reenterpasswordFieldText.isSecureTextEntry = true
            showPassword2.setTitle("Show", for: .normal)
        }
    }
    
    @IBAction func ShowPassword2(_ sender: Any) {
        if showPassword1.titleLabel?.text == "Show"{
            passwordFieldText.isSecureTextEntry = false
            reenterpasswordFieldText.isSecureTextEntry = false
            showPassword1.setTitle("Hide", for: .normal)
            showPassword2.setTitle("Hide", for: .normal)
            
        }
        else{
            passwordFieldText.isSecureTextEntry = true
            showPassword1.setTitle("Show", for: .normal)
            reenterpasswordFieldText.isSecureTextEntry = true
            showPassword2.setTitle("Show", for: .normal)
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        self.performSegue(withIdentifier: "Back", sender: self)
        
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
