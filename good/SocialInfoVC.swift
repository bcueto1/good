//
//  SocialInfoVC.swift
//  good
//
//  Created by Brian Cueto on 4/28/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit
import Firebase

class SocialInfoVC: UIViewController {
    
    var formID: String!
    var otherUser: User!
    var currentUserFirstName: String!
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var userDataRef = UserDataService()
    
    @IBOutlet weak var postImage: RoundImage!
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var postZipcodeLabel: UILabel!
    @IBOutlet weak var postRatingLabel: UILabel!
    @IBOutlet weak var postTypeLabel: UILabel!
    @IBOutlet weak var postSpecificLabel: UILabel!
    @IBOutlet weak var postMessageLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadUserInfo()
        self.populateData()
    }
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "infoToChat") {
            let chatController = segue.destination as? ChatVC
            chatController?.userFirstname = self.currentUserFirstName
        }
    }
    
    func populateData() {
        let currentUser = FIRAuth.auth()?.currentUser
        
        let formRef = self.databaseRef.child("forms").child(self.formID)
        formRef.observeSingleEvent(of: .value, with: { (formSnapshot) in
            let form = Form(snapshot: formSnapshot)
            self.postZipcodeLabel.text = form.zipcode
            self.postTypeLabel.text = form.type
            self.postMessageLabel.text = form.message
            if (form.submitterUID == currentUser?.uid) {
                let userRef = self.databaseRef.child("users").child(form.takerUID)
                userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let user = User(snapshot: snapshot)
                    let picURL = user.profilePicURL
                    self.downloadImageFromFirebase(urlString: picURL)
                    self.postNameLabel.text = user.firstName
                }) { (error) in
                    print(error.localizedDescription)
                }
            } else if (form.takerUID == currentUser?.uid) {
                let userRef = self.databaseRef.child("users").child(form.submitterUID)
                userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let user = User(snapshot: snapshot)
                    let picURL = user.profilePicURL
                    self.downloadImageFromFirebase(urlString: picURL)
                    self.postNameLabel.text = user.firstName
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
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
    
    func loadUserInfo() {
        let currentUser = FIRAuth.auth()!.currentUser!
        let userRef = databaseRef.child("users").child(currentUser.uid)
        
        userRef.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let user = User(snapshot: currentUser)
            self.currentUserFirstName = user.firstName
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    

}
