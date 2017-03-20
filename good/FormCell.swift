//
//  UserCell.swift
//  good
//
//  Created by Brian Cueto on 1/17/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit
import Firebase

class FormCell: UITableViewCell {
    
    var thisFormID = String()
    
    /** Outlets */
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    /** Reference to database */
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        let currentUser = FIRAuth.auth()?.currentUser
        let formRef = databaseRef.child("forms").child(self.thisFormID)
        
        formRef.observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            let form = Form(snapshot: snapshot)
            if (form.submitterUID == currentUser?.uid) {
                formRef.child("doneBySubmitter").setValue(true)
            } else {
                formRef.child("doneByTaker").setValue(true)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    /**
     * Configures the cell for the form.
     *
     */
    func configureCellForForm(form: Form) {
        self.updateFirstName(form: form)
        self.updateTypeLabel(form: form)
        self.updateMessageLabel(form: form)
        self.thisFormID = form.postID
        
        let currentUser = FIRAuth.auth()?.currentUser
        
        if (form.submitterUID == currentUser?.uid) {
            let userRef = databaseRef.child("users").child(form.takerUID)
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let picURL = value?["profilePicURL"] as? String ?? ""
                self.downloadImageFromFirebase(urlString: picURL)
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            let userRef = databaseRef.child("users").child(form.submitterUID)
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let picURL = value?["profilePicURL"] as? String ?? ""
                self.downloadImageFromFirebase(urlString: picURL)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        /**
        if (form.doneByTaker && form.doneBySubmitter) {
            self.checkmarkImage.backgroundColor = UIColor.green
        } **/
        
    }
    
    
    func updateFirstName(form: Form) {
        self.firstNameLbl.text = form.firstName
    }
    
    func updateTypeLabel(form: Form) {
        self.typeLabel.text = form.type
    }
    
    func updateMessageLabel(form: Form) {
        self.messageLabel.text = form.message
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
                        self.userPicture.image = UIImage(data: data)
                    })
                }
            }
        }
    }
    

}
