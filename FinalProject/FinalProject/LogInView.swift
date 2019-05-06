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
       
    //googleButton.addTarget(self, action: #selector(toMain), for: .touchUpInside)
        
    }
    @objc public func toMain(){
        performSegue(withIdentifier: "toMain", sender: self)
    }
    

