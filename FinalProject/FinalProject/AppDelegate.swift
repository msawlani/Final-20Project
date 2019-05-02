//
//  AppDelegate.swift
//  FinalProject
//
//  Created by Victor  Perez on 4/4/19.
//  Copyright © 2019 FullSailUniversity. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
var sigedIn = true
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
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
            print("User is signed in to FireBase with Google",user.userID)
            self.window?.rootViewController?.performSegue(withIdentifier: "toMain", sender: nil)
        }
    }
    

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
         GIDSignIn.sharedInstance().delegate = self
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                          annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

