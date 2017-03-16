//
//  AuthService.swift
//  good
//
//  Created by Brian Cueto on 1/10/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper

/**
 * Authetication Service Struct used when creating new users and dealing with login.
 *
 */
struct AuthService {
    
    /** Database Reference */
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    /** Storage reference */
    var storageRef: FIRStorageReference! {
        return FIRStorage.storage().reference()
    }
    
    /**
     *  Sign up function that creates the user and sets information in the database.
     *
     */
    func signUp(firstName: String, email: String, pictureData: Data, password: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                
                self.setUser(user: user, firstName: firstName, pictureData: pictureData, password: password)
                
            }
            
        })
    }
    
    /**
     * Sets the user information.  This method handles a the profile picture.
     *
     */
    private func setUser(user: FIRUser!, firstName: String, pictureData: Data, password: String) {
        
        let proPicPath = "profileImage\(user.uid)image.jpg"
        let proPicRef = storageRef.child(proPicPath)
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        
        proPicRef.put(pictureData, metadata: metaData) { (newMetaData, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                
                let changeReq = user.profileChangeRequest()
                changeReq.displayName = "\(firstName)"
                
                if let url = newMetaData?.downloadURL() {
                    changeReq.photoURL = url
                }
                
                changeReq.commitChanges(completion: { (error) in
                    if error == nil {
                        self.saveUser(user: user, firstName: firstName, password: password)
                        
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            }
        }
    }
    
    /**
     * Saves the user to Firebase.
     *
     */
    private func saveUser(user: FIRUser!, firstName: String, password: String) {
        
        let userRef = databaseRef.child("users").child(user.uid)
        let newUser = User(firstName: firstName, email: user.email!, uid: user.uid, profilePicURL: String(describing: user.photoURL!))
        
        userRef.setValue(newUser.toAnyObject()) { (error, ref) in
            if error == nil {
                print("\(firstName) has been saved!")
            } else {
                print(error!.localizedDescription)
            }
        }
        
        self.signIn(email: user.email!, password: password)
    }
    
    /**
     * Signs in the user to the application.
     *
     */
    func signIn(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                if let user = user {
                    print("\(user.displayName!) has logged in!")
                    
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    appDel.takeToHome()
                    
                    self.completeSignIn(id: user.uid)
                    
                }
                
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
    /**
     * Function that makes sure the user does not have to keep logging back in once signed in.
     *
     */
    func completeSignIn(id: String) {
        _ = KeychainWrapper.standard.set(id, forKey: "uid")
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.takeToHome()
    }
    
    
    
}
