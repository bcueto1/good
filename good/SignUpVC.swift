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

/**
 * View Controller for user to sign up for first time.
 *
 */
class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    UIPopoverPresentationControllerDelegate, UIPickerViewDelegate {
    
    /** Outlets */
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileImageView: RoundImage!
    @IBOutlet weak var signUpButton: AspectFitButton!
    

    /** Auth Service */
    var authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    /**
     * Validates proper sign up credentials, then sends to Firebase to handle.
     *
     */
    @IBAction func signUpTapped(_ sender: Any) {
        
        let data = UIImageJPEGRepresentation(self.profileImageView.image!, 0.2)
        
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
        } else if profileImageView.image == UIImage(named: "propicDefault") {
            // If there was no picture entered
            let alertController = UIAlertController(title: "Error", message: "Please enter a picture", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            self.authService.signUp(firstName: self.nameTextField.text!, email: self.emailTextField.text!, pictureData: data!, password: self.passwordTextField.text!)
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        performSegue(withIdentifier: "backToLogin", sender: nil)
    }
}

/** Extention for SignUpVC that gives image picker functionality. */
extension SignUpVC {
    
    @IBAction func choosePictureAction(_ sender: UITapGestureRecognizer) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.modalPresentationStyle = .popover
        pickerController.popoverPresentationController?.delegate = self
        pickerController.popoverPresentationController?.sourceView = profileImageView
        let alertController = UIAlertController(title: "Add a Picture", message: "Choose From", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImageView.image = chosenImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
