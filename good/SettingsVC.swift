//
//  SettingsVC.swift
//  good
//
//  Created by Brian Cueto on 1/17/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

/**
 * Settings View Controller where user can change information.
 *
 */
class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, UIPickerViewDelegate {
    
    /** Outlets */
    @IBOutlet weak var editNameField: UITextField!
    @IBOutlet weak var profileImageView: RoundImage!
    @IBOutlet weak var saveButton: AspectFitButton!
    
    /** User data service reference */
    var userDataService = UserDataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    /**
     * If save tapped, then save the new name and profile picture.
     *
     */
    @IBAction func saveTapped(_ sender: Any) {
        let currentUser = FIRAuth.auth()!.currentUser!
        let data = UIImageJPEGRepresentation(self.profileImageView.image!, 0.2)
        
        if self.editNameField.text != "" {
            self.userDataService.updateUserName(user: currentUser, firstName: self.editNameField.text!)
        }
        if self.profileImageView.image != UIImage(named: "propicDefault") {
            self.userDataService.updateProfilePicture(user: currentUser, pictureData: data!)
        }
        performSegue(withIdentifier: "settingsToProfile", sender: nil)
        
    }
    
    /**
     * If back is tapped, then send user back to profile.
     *
     */
    @IBAction func backTapped(_ sender: Any) {
        self.editNameField.text = ""
        
    }
    
    
    /**
     * If sign out was tapped, then sign the user out as well as remove UID from KeyChainWrapper.
     *
     */
    @IBAction func signOutTapped(_ sender: Any) {
        _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! SignInVC
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = newVC
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

}

/**
 * Extention for SettingsVC which include functions for changing image.
 *
 */
extension SettingsVC {
    /**
     * When the area around the image is tapped, create functionality for saving and picking images.
     *
     */
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
    
    /**
     * When image picked, update the image on the screen.
     *
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImageView.image = chosenImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     * When picker view is cancelled, then just dismiss it.
     *
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
