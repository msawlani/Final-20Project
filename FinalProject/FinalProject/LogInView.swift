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
import Firebase

class LogInView: UIViewController,GIDSignInUIDelegate, GIDSignInDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Add Signin Button
        let googleButton = GIDSignInButton()
        googleButton.frame =  CGRect(x:16,y:650,width: view.frame.width - 32,height:50)
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        let loginButton = UIButton.init()
        loginButton.frame = CGRect(x: 16, y: 590, width: view.frame.width - 32, height: 50)
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor.black
        loginButton.tintColor = UIColor.white
        loginButton.addTarget(self, action: #selector(toLogin(_:)), for: .touchUpInside)
        view.addSubview(loginButton)
    //googleButton.addTarget(self, action: #selector(toMain), for: .touchUpInside)
        
    }
    //Checking if thers is a log in error
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error{
            print("Failed to Log In to Google",err)
            return
        }
        print("Logged Into Google",user)
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let err = error {
                print("Failed To log in With Google",err)
                return
            }
            else{
            print("User is signed in to FireBase with Google",user.userID)
            self.performSegue(withIdentifier: "toMain", sender: nil)
            }
        }
    }
    
    @objc public func toMain(){
        //performSegue(withIdentifier: "toMain", sender: self)
    }
    
    //sends the user to the firebase login screen - Michael Sawlani
    @objc public func toLogin(_ :UIButton){
        performSegue(withIdentifier: "Login", sender: self)
    }
    
}
