//
//  LogInView.swift
//  FinalProject
//
//  Created by Victor  Perez on 4/11/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI

class LogInView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        //Get the default UI object
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else{
            //log error
            return
        }
        //Set ourselves as delegates
        authUI?.delegate = self
        //Get a reference to the auth UI view controller
        let authViewController = authUI!.authViewController()
        //Show it
        present(authViewController, animated: true, completion: nil)
        }
}
extension UIViewController: FUIAuthDelegate{
    private func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        //check if there was an error
        if error != nil{
            //log error
            return
        }
        //to get user id : authDataResult?.user.uid
        performSegue(withIdentifier: "GoToMain", sender: self)
    }
}
