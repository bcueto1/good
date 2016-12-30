//
//  SignInVC.swift
//  good
//
//  Created by Brian Cueto on 12/29/16.
//  Copyright © 2016 Brian-good. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")  
    }
    
    @IBAction func facebookBtnTapped(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Unable to login to Facebook!")
            } else if result?.isCancelled == true {
                print("User cancelled login to Facebook.")
            } else {
                print("Logged in to Facebook!")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Unable to authenticate with Firebase - \(error)")
            } else {
                print("Successfully authenticated with Firebase")
            }
        })
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("Successfully authenticated with Firebase using email already entered")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("Unable to authenticate with Firebase")
                        } else {
                            print("Successfully authenticated with Firebase with new email")
                        }
                    })
                }
            })
        }
        
    }
    
}
