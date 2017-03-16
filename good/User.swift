//
//  User.swift
//  good
//
//  Created by Brian Cueto on 1/10/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

/**
 * User struct that defines all the variables and data needed for a user.
 *
 */
struct User {
    
    /** private variables */
    private var _firstName: String
    private var _email: String
    private var _rating: NSNumber
    private var _points: Int
    private var _offers: Int
    private var _requests: Int
    private var _weeklyOffers: Int
    private var _weeklyRequests: Int
    private var _uid: String
    private var _profilePicURL: String
    private var ref: FIRDatabaseReference!
    private var key: String?
    
    /**
     * Initializer based on Firebase snapshot.
     *
     */
    init(snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        self.ref = snapshot.ref
        self._uid = ((snapshot.value! as! NSDictionary)["uid"] as? String)!
        self._email = ((snapshot.value! as! NSDictionary)["email"] as? String)!
        self._firstName = (snapshot.value! as! NSDictionary)["firstName"] as! String
        self._profilePicURL = (snapshot.value! as! NSDictionary)["profilePicURL"] as! String
        self._rating = (snapshot.value! as! NSDictionary)["rating"] as! NSNumber
        self._points = (snapshot.value! as! NSDictionary)["points"] as! Int
        self._offers = (snapshot.value! as! NSDictionary)["offers"] as! Int
        self._requests = (snapshot.value! as! NSDictionary)["requests"] as! Int
        self._weeklyOffers = (snapshot.value! as! NSDictionary)["weeklyOffers"] as! Int
        self._weeklyRequests = (snapshot.value! as! NSDictionary)["weeklyRequests"] as! Int
    }
    
    /**
     * Original initializer used when creating a new user to firebase.
     *
     */
    init(firstName: String, email: String, uid: String, profilePicURL: String) {
        self.key = ""
        self.ref = FIRDatabase.database().reference()
        self._uid = uid
        self._email = email
        self._firstName = firstName
        self._profilePicURL = profilePicURL
        self._rating = 0.0
        self._points = 0
        self._offers = 0
        self._requests = 0
        self._weeklyOffers = 0
        self._weeklyRequests = 0
    }
    
    /**
     * Returns a dictionary with values of the user to be pushed to Firebase.
     *
     */
    func toAnyObject() -> [String: Any] {
        return ["firstName": firstName, "email": email, "uid": uid, "profilePicURL": profilePicURL, "rating": rating, "points": points, "offers": offers, "requests": requests, "weeklyOffers": weeklyOffers, "weeklyRequests": weeklyRequests]
    }
    
    //Getters and Setters
    var uid: String {
        return _uid
    }
    
    var firstName: String {
        get {
            return _firstName
        }
        set (newFirstName) {
            _firstName = newFirstName
        }
    }
    
    var email: String {
        get {
            return _email
        }
        set (newEmail) {
            _email = newEmail
        }
    }
    
    var profilePicURL: String {
        get {
            return _profilePicURL
        } set(newProPicURL) {
            _profilePicURL = newProPicURL
        }
    }
    
    var rating: NSNumber {
        get {
            return _rating
        }
        set (newRating) {
            _rating = newRating
        }
    }
    
    var points: Int {
        get {
            return _points
        }
        set (newPoints) {
            _points = newPoints
        }
    }
    
    var offers: Int {
        get {
            return _offers
        }
        set (newOffers) {
            _offers = newOffers
        }
    }
    
    var requests: Int {
        get {
            return _requests
        }
        set (newRequests) {
            _requests = newRequests
        }
    }
    
    var weeklyOffers: Int {
        get {
            return _weeklyOffers
        }
        set (newWeeklyOffers) {
            _weeklyOffers = newWeeklyOffers
        }
    }
    
    var weeklyRequests: Int {
        get {
            return _weeklyRequests
        }
        set (newWeeklyRequests) {
            _weeklyRequests = newWeeklyRequests
        }
    }
}
