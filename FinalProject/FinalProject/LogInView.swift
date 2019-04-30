//
//  LogInView.swift
//  FinalProject
//
//  Created by Victor  Perez on 4/11/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import FirebaseUI
import GoogleSignIn

class LogInView: UIViewController,GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Add Signin Button
        let googleButton = GIDSignInButton()
        googleButton.frame =  CGRect(x:16,y:650,width: view.frame.width - 32,height:50)
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance()?.uiDelegate = self
        googleButton.addTarget(self, action: #selector(toMain), for: .touchUpInside)
    }
    @objc func toMain(){
        performSegue(withIdentifier: "toMain", sender: self)
    }
    
    @IBAction func onClick(_ sender: UIButton) {
        //Get the default UI object
                let authUI = FUIAuth.defaultAuthUI()
        
                guard authUI != nil else{
                    //log error
                    print("There was an authentication error")
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

//extention for email signin:

extension LogInView: FUIAuthDelegate{
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        //check if there was an error
        if error != nil{
            //log error
            return
        }
        //to get user id : authDataResult?.user.uid
        performSegue(withIdentifier: "toMain", sender: self)
    }

}

