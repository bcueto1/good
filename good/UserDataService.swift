//
//  DataService.swift
//  good
//
//  Created by Brian Cueto on 1/17/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

/**
 * Data Service struct used whenever user information is needed or needs to be updated.
 *
 */
struct UserDataService {
    
    /** Reference to database */
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    /** Reference to storage. */
    var storageRef: FIRStorageReference! {
        return FIRStorage.storage().reference()
    }
    
    /** Reference to users branch */
    var usersRef: FIRDatabaseReference {
        return databaseRef.child("users")
    }
    
    func getCurrentUserId() -> String {
        return FIRAuth.auth()!.currentUser!.uid
    }

    
    /** 
     * Adds a new request form to the User
     *
     */
    func addNewRequestForm(user: FIRUser!, form: Form) {
        self.usersRef.child(user.uid).child("myForms").child("myRequests").child(form.postID).setValue(form.postID)
        self.incrementRequest(user: user)
        
    }
    
    /**
     * Increases the value of total requests and weekly requests.
     *
     */
    func incrementRequest(user: FIRUser!) {
        let currentUser = FIRAuth.auth()!.currentUser!
        let userRef = self.usersRef.child(currentUser.uid)
        userRef.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let thisUser = User(snapshot: currentUser)
            let totalRequests = thisUser.requests + 1
            let weeklyRequests = thisUser.weeklyRequests + 1
            self.usersRef.child(user.uid).child("requests").setValue(totalRequests)
            self.usersRef.child(user.uid).child("weeklyRequests").setValue(weeklyRequests)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    func removeRequestForm(userID: String, form: Form) {
        self.usersRef.child(userID).child("myForms").child("myRequests").child(form.postID).removeValue()
        self.decrementRequestForm(userID: userID)
    }
    
    func decrementRequestForm(userID: String) {
        let userRef = self.usersRef.child(userID)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let thisUser = User(snapshot: snapshot)
            let totalRequests = thisUser.requests - 1
            let weeklyRequests = thisUser.weeklyRequests - 1
            self.usersRef.child(userID).child("requests").setValue(totalRequests)
            self.usersRef.child(userID).child("weeklyRequests").setValue(weeklyRequests)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    /**
     * Adds a new offer form to the User
     *
     */
    func addNewOfferForm(user: FIRUser!, form: Form) {
        self.usersRef.child(user.uid).child("myForms").child("myOffers").child(form.postID).setValue(form.postID)
        self.incrementOffers(user: user)
    }
    
    /**
     * Increases the value of total offers and weekly offers.
     *
     */
    func incrementOffers(user: FIRUser!) {
        let currentUser = FIRAuth.auth()!.currentUser!
        let userRef = self.usersRef.child(currentUser.uid)
        userRef.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let thisUser = User(snapshot: currentUser)
            let totalOffers = thisUser.offers + 1
            let weeklyOffers = thisUser.weeklyOffers + 1
            self.usersRef.child(user.uid).child("offers").setValue(totalOffers)
            self.usersRef.child(user.uid).child("weeklyOffers").setValue(weeklyOffers)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func removeOfferForm(userID: String, form: Form) {
        self.usersRef.child(userID).child("myForms").child("myOffers").child(form.postID).removeValue()
        self.decrementOfferForm(userID: userID)
    }
    
    func decrementOfferForm(userID: String) {
        let userRef = self.usersRef.child(userID)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let thisUser = User(snapshot: snapshot)
            let totalOffers = thisUser.offers - 1
            let weeklyOffers = thisUser.weeklyOffers - 1
            self.usersRef.child(userID).child("offers").setValue(totalOffers)
            self.usersRef.child(userID).child("weeklyOffers").setValue(weeklyOffers)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    /**
     * Updates the username to firebase based on user id.
     *
     */
    func updateUserName(user: FIRUser!, firstName: String) {
        self.usersRef.child(user.uid).child("firstName").setValue(firstName)
    }
    
    /**
     * Handles updating the profile picture and updating it.
     *
     */
    func updateProfilePicture(user: FIRUser!, pictureData: Data) {
        let proPicPath = "profileImage\(user.uid)image.jpg"
        let proPicRef = storageRef.child(proPicPath)
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        
        proPicRef.put(pictureData, metadata: metaData) { (newMetaData, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                
                let changeReq = user.profileChangeRequest()
                
                if let url = newMetaData?.downloadURL() {
                    changeReq.photoURL = url
                }
                
                changeReq.commitChanges(completion: { (error) in
                    if error == nil {
                        self.usersRef.child(user.uid).child("profilePicURL").setValue(String(describing: user.photoURL!))
                        
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            }
        }
    }
    
    func addRating(user: User, rating: Double) {
        var currentRating = Double(user.rating)
        var totalRatings = user.totalRatings
        
        var ratingSum = currentRating * Double(totalRatings)
        ratingSum += rating
        totalRatings += 1
        currentRating = ratingSum/Double(totalRatings)
        let newRating = currentRating as NSNumber
        
        self.usersRef.child(user.uid).child("totalRatings").setValue(totalRatings)
        self.usersRef.child(user.uid).child("rating").setValue(newRating)
        
    }
    
    /**
     * Adds points to a given user.
     *
     */
    func addPoints(user: User, points: Int) {
        var currentPoints = user.points
        currentPoints = currentPoints + points
        
        self.usersRef.child(user.uid).child("points").setValue(currentPoints)
    }
    
    /**
     * Adds points to current user.
     *
     */
    func addPoints(points: Int) {
        let currentUser = FIRAuth.auth()!.currentUser!
        let userRef = self.usersRef.child(currentUser.uid)
        userRef.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let thisUser = User(snapshot: currentUser)
            var currentPoints = thisUser.points
            currentPoints = currentPoints + points
            userRef.child("points").setValue(currentPoints)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    
}
