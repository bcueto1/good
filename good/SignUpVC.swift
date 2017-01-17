//
//  SignUpVC.swift
//  good
//
//  Created by Brian Cueto on 1/4/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import Photos

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //----- OUTLETS ----------//
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pictureButton: UIButton!
    
    // Initialize the UIImagePickerController
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }
    
    // Allows the user to change the photo
    @IBAction func photoButtonTapped(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    // Validates proper sign up credentials, then sends to Firebase to handle
    @IBAction func signUpTapped(_ sender: Any) {
        if emailTextField.text == "" {
            // If no email was entered
            let alertController = UIAlertController(title: "Error", message: "Please enter your email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else if passwordTextField.text! == "" || (passwordTextField.text?.characters.count)! < 8 {
            // If the password is invalid
            let alertController = UIAlertController(title: "Error", message: "Please enter a valid password greater than 8 characters.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else if passwordTextField.text != reenterPasswordTextField.text {
            // If both password fields do not match
            let alertController = UIAlertController(title: "Error", message: "Password fields do not match!", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else if nameTextField.text == "" {
            // If there was no name entered
            let alertController = UIAlertController(title: "Error", message: "Please enter your first name", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            // Sends information to Firebase to handle
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    DataService.instance.saveUser(uid: user!.uid)
                    print("You have successfully signed up")
                    
                    FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                        
                        if error == nil {
                            
                            //Print into the console if successfully logged in
                            print("You have successfully logged in")
                            
                            //Go to the MapVC if the login is sucessful
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                            
                        } else {
                            
                            //Tells the user that there is an error and then gets firebase to tell them the error
                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Allows for automatic signing in
    func completeSignIn(id: String) {
        _ = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
        let storyboard = UIStoryboard(name: "main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "MapVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = newVC
    }
    
    // -------- imagePickerController functions -------//
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        pictureButton.imageView?.contentMode = .scaleAspectFit
        pictureButton.imageView?.image = chosenImage
        dismiss(animated:true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
