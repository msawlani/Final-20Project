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

        view.backgroundColor = UIColor.gray

        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        //Add Signin Button
        let googleButton = GIDSignInButton()
        googleButton.frame =  CGRect(x:16,y:450,width: view.frame.width - 32,height:50)
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        GIDSignIn.sharedInstance()?.uiDelegate = self

        let loginButton = UIButton.init()
        loginButton.frame = CGRect(x: 16, y: 400, width: view.frame.width - 32, height: 50)
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor.black
        loginButton.tintColor = UIColor.white
        loginButton.addTarget(self, action: #selector(toLogin(_:)), for: .touchUpInside)
        view.addSubview(loginButton)
    //googleButton.addTarget(self, action: #selector(toMain), for: .touchUpInside)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true

    }
    
    //Checking if thers is a log in error
    func sign(_ signIn: GIDSignIn!, didSignInFor _user: GIDGoogleUser!, withError error: Error!) {
        if let err = error{
            print("Failed to Log In to Google",err)
            return
        }
        print("Logged Into Google",_user)

        guard let authentication = _user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)

        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let err = error {
                print("Failed To log in With Google",err)
                return
            }
            else{
                print("User is signed in to FireBase with Google",_user.userID)
                googleUser = _user
                signedInWithGoogle = true
                //Retrieve user data from Firebase and store it in user variable
                mainUser.userId = Auth.auth().currentUser!.uid

//                GetUser(userId: mainUser.userId, callback: { mainUser in
//                    mainUser.email = googleUser.profile.email
//                    mainUser.imageURL = googleUser.profile.imageURL(withDimension: 112)
//                    mainUser.firstName = googleUser.profile.givenName
//                    mainUser.lastName = googleUser.profile.familyName
//                    mainUser.StoreInFirebase()
//                    self.performSegue(withIdentifier: "toMain", sender: nil)
//                })
                //Justin

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
