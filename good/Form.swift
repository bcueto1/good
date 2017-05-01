//
//  Form.swift
//  good
//
//  Created by Brian Cueto on 1/14/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

/**
 * Form struct that describes all the variables and information for a proper form.
 *
 */
struct Form {
    
    /** private variables */
    private var _request: Bool!
    private var _type: String!
    //private var _specific: String!
    private var _firstName: String!
    private var _zipcode: String!
    private var _message: String!
    private var _postID: String!
    private var _formDate: NSNumber!
    private var _submitterUID: String!
    private var _takerUID: String!
    private var _latitude: NSNumber!
    private var _longitude: NSNumber!
    private var _completed: Bool!
    private var _doneBySubmitter: Bool!
    private var _doneByTaker: Bool!
    private var ref: FIRDatabaseReference!
    private var key: String?
    
    /**
     * Initializer using Firebase snapshot.
     *
     */
    init(snapshot: FIRDataSnapshot) {
        self.key = snapshot.key
        self.ref = snapshot.ref
        self._postID = ((snapshot.value! as! NSDictionary)["postID"] as? String)!
        self._formDate = ((snapshot.value! as! NSDictionary)["formDate"] as? NSNumber)!
        self._submitterUID = ((snapshot.value! as! NSDictionary)["submitterUID"] as? String)!
        self._takerUID = ((snapshot.value! as! NSDictionary)["takerUID"] as? String)!
        self._request = ((snapshot.value! as! NSDictionary)["request"] as? Bool)!
        self._type = (snapshot.value! as! NSDictionary)["type"] as! String
        //self._specific = (snapshot.value! as! NSDictionary)["specific"] as! String
        self._firstName = (snapshot.value! as! NSDictionary)["firstName"] as! String
        self._zipcode = (snapshot.value! as! NSDictionary)["zipcode"] as! String
        self._message = (snapshot.value! as! NSDictionary)["message"] as! String
        self._latitude = (snapshot.value! as! NSDictionary)["latitude"] as! NSNumber
        self._longitude = (snapshot.value! as! NSDictionary)["longitude"] as! NSNumber
        self._completed = ((snapshot.value! as! NSDictionary)["completed"] as? Bool)!
        self._doneBySubmitter = ((snapshot.value! as! NSDictionary)["doneBySubmitter"] as? Bool)!
        self._doneByTaker = ((snapshot.value! as! NSDictionary)["doneByTaker"] as? Bool)!
    }
    
    /**
     * Original initializer used when creating a new form to firebase.
     *
     */
    init(request: Bool, type: String, firstName: String, zipcode: String, message: String, latitude: NSNumber, longitude: NSNumber, postID: String, formDate: NSNumber, submitterUID: String) {
        self.key = ""
        self.ref = FIRDatabase.database().reference()
        self._postID = postID
        self._formDate = formDate
        self._submitterUID = submitterUID
        self._takerUID = ""
        self._request = request
        self._type = type
        //self._specific = specific
        self._firstName = firstName
        self._zipcode = zipcode
        self._message = message
        self._latitude = latitude
        self._longitude = longitude
        self._completed = false
        self._doneBySubmitter = false
        self._doneByTaker = false
    }
    
    /**
     * Returns form values in dictionary to be stored in Firebase.
     *
     */
    func toAnyObject() -> [String: Any] {
        return ["postID": postID, "formDate": formDate, "submitterUID": submitterUID, "takerUID": takerUID, "request": request, "type": type, "firstName": firstName, "zipcode": zipcode, "message": message, "latitude": latitude, "longitude": longitude, "completed": completed, "doneBySubmitter": doneBySubmitter, "doneByTaker": doneByTaker]
    }
    
    /** Getters and Setters */
    var postID: String {
        return self._postID
    }
    
    var formDate: NSNumber {
        return self._formDate
    }
    
    var submitterUID: String {
        return self._submitterUID
    }
    
    var takerUID: String {
        return self._takerUID
    }
    
    var request: Bool {
        get {
            return self._request
        }
        set (changeRequest) {
            self._request = changeRequest
        }
    }
    
    var type: String {
        get {
            return self._type
        }
        set (newType) {
            self._type = newType
        }
    }
    
    /*
    var specific: String {
        get {
            return self._specific
        }
        set (newspecific) {
            self._specific = newspecific
        }
    }*/
    
    var firstName: String {
        get {
            return self._firstName
        }
        set (newFirstName) {
            self._firstName = newFirstName
        }
    }
    
    var zipcode: String {
        get {
            return self._zipcode
        }
        set (newZipCode) {
            self._zipcode = newZipCode
        }
    }
    
    var message: String {
        get {
            return self._message
        }
        set (newMessage) {
            self._message = newMessage
        }
    }
    
    var latitude: NSNumber {
        get {
            return self._latitude
        }
        set (newLatitude) {
            self._latitude = newLatitude
        }
    }
    
    var longitude: NSNumber {
        get {
            return self._longitude
        }
        set (newLongitude) {
            self._longitude = newLongitude
        }
    }
    
    var completed: Bool {
        get {
            return self._completed
        }
        set (newCompleted) {
            self._completed = newCompleted
        }
    }
    
    var doneBySubmitter: Bool {
        get {
            return self._doneBySubmitter
        }
        set (newDone) {
            self._doneBySubmitter = newDone
        }
    }
    
    var doneByTaker: Bool {
        get {
            return self._doneByTaker
        }
        set (newDone) {
            self._doneByTaker = newDone
        }
    }
}
