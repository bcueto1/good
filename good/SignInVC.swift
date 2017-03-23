//
//  SignInVC.swift
//  good
//
//  Created by Brian Cueto on 12/29/16.
//  Copyright © 2016 Brian-good. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

/**
 * Sign In view controller where the user gets to login.
 *
 */
class SignInVC: UIViewController {

    /** Outlets */
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: AspectFitButton?
    
    /** Auth Service */
    var authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    /**
     * Override viewDidAppear to handle a user already signed in.
     *
     */
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.takeToHome()
        }
    }
    
    /**
     * Handles log in functionality.
     *
     */
    @IBAction func logInTapped(_ sender: Any) {
        // If the email or password fields are blank
        if self.emailField.text == "" || self.passwordField.text == "" {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            self.authService.signIn(email: self.emailField.text!, password: self.passwordField.text!)
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        performSegue(withIdentifier: "goSignUp", sender: nil)
    }
    
    
}

/** Extention for more functions */
extension SignInVC {
    
    
    //Facebook authentication, to be completed later
    /*
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
     if let user = user {
     self.completeSignIn(id: user.uid)
     }
     }
     })
     } */
    
    
    
}
