//
//  FormDataService.swift
//  good
//
//  Created by Brian Cueto on 3/6/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import Foundation
import Firebase

/**
 * Struct that deals with the form data service when making new forms and updating form info.
 *
 */
struct FormDataService {
    
    /** Reference to database */
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    /** Reference to storage */
    var storageRef: FIRStorageReference! {
        return FIRStorage.storage().reference()
    }
    
    /** Reference to the forms branch */
    var formsRef: FIRDatabaseReference {
        return databaseRef.child("forms")
    }
    
    var userData = UserDataService()
    
    /**
     * Instantiate new form into firebase.
     *
     */
    func createNewForm(request: Bool, type: String, firstName: String, zipcode: String, message: String, latitude: NSNumber, longitude: NSNumber) {
        let currentUser = FIRAuth.auth()!.currentUser!
        let postID = NSUUID().uuidString
        let postDate = NSDate().timeIntervalSince1970 as NSNumber
        let form = Form(request: request, type: type, firstName: firstName, zipcode: zipcode, message: message, latitude: latitude, longitude: longitude, postID: postID, formDate: postDate, submitterUID: currentUser.uid)
        
        formsRef.child(postID).setValue(form.toAnyObject()) { (error, ref) in
            if error == nil {
                if request == true {
                    self.userData.addNewRequestForm(user: currentUser, form: form)
                } else if request == false {
                    self.userData.addNewOfferForm(user: currentUser, form: form)
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    /**
     * Adds a taker to the form.
     *
     */
    func addTakerToForm(takerID: String, form: Form) {
        self.formsRef.child(form.postID).child("takerUID").setValue(takerID)
    }
    
    
    
    
}
