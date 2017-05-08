//
//  MapFormVC.swift
//  good
//
//  Created by Brian Cueto on 5/7/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit
import Firebase
import Cosmos

class MapFormVC: UIViewController {

    var formID: String!
    var currentForm: Form!
    
    /** Form Data Service */
    var formService = FormDataService()
    /** User Data Service */
    var userService = UserDataService()
    /** Reference to database */
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    @IBOutlet weak var postImage: RoundImage!
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var postZipcodeLabel: UILabel!
    @IBOutlet weak var postTypeLabel: UILabel!
    @IBOutlet weak var postSpecificLabel: UILabel!
    @IBOutlet weak var postMessageLabel: UITextView!
    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.starView.settings.updateOnTouch = false
        self.starView.settings.fillMode = .precise
        
        self.populateData()
    }
    
    
    @IBAction func editButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func selectButtonTapped(_ sender: Any) {
        let user = FIRAuth.auth()!.currentUser!
        let form = self.currentForm
        let addJob = UIAlertController(title: "Accept?", message: "Would you like to accept this request?", preferredStyle: UIAlertControllerStyle.alert)
        let acceptAction = UIAlertAction(title: "Accept", style: .default, handler: { (UIAlertAction) in
            
            self.formService.addTakerToForm(takerID: user.uid, form: form!)
            if (form?.request)! {
                self.userService.addNewOfferForm(user: user, form: form!)
            } else {
                self.userService.addNewRequestForm(user: user, form: form!)
            }
            
            self.performSegue(withIdentifier: "formToMap", sender: nil)
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addJob.addAction(acceptAction)
        addJob.addAction(cancelAction)
        present(addJob, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "formToMap", sender: nil)
    }
    
    
    /**
     * Populate the data from form and the other user.
     *
     */
    func populateData() {
        let currentUser = FIRAuth.auth()?.currentUser
        
        let formRef = self.databaseRef.child("forms").child(self.formID)
        formRef.observeSingleEvent(of: .value, with: { (formSnapshot) in
            let form = Form(snapshot: formSnapshot)
            self.postZipcodeLabel.text = form.zipcode
            self.postTypeLabel.text = form.type
            self.postSpecificLabel.text = form.specific
            self.postMessageLabel.text = form.message
            
            let userRef = self.databaseRef.child("users").child(form.submitterUID)
            if (form.submitterUID == currentUser?.uid) {
                self.selectButton.isHidden = true
                self.editButton.isHidden = false
            }
            
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                let picURL = user.profilePicURL
                self.downloadImageFromFirebase(urlString: picURL)
                self.postNameLabel.text = user.firstName
                self.starView.rating = user.rating as Double!
            }) { (error) in
                print(error.localizedDescription)
            }
            
            self.currentForm = form
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    /**
     * Downloads the user profile picture from the Firebase Storage.
     *
     */
    func downloadImageFromFirebase(urlString: String) {
        let storageRef = FIRStorage.storage().reference(forURL: urlString)
        storageRef.data(withMaxSize: 1 * 1024 * 1024) { (imageData, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if let data = imageData {
                    DispatchQueue.main.async(execute: {
                        self.postImage.image = UIImage(data: data)
                    })
                }
            }
        }
    }


}
