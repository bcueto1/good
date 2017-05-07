//
//  Message.swift
//  good
//
//  Created by Brian Cueto on 3/17/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import Foundation
import Firebase

/**
 * Message struct that stores information about messages being sent.
 *
 */
struct Message {
    
    var _text: String!
    var _senderID: String!
    var _username: String!
    var ref: FIRDatabaseReference!
    var key: String = ""
    
    init(snapshot: FIRDataSnapshot) {
        self._text = (snapshot.value! as! NSDictionary)["text"] as! String
        self._senderID = (snapshot.value! as! NSDictionary)["senderID"] as! String
        self._username = (snapshot.value! as! NSDictionary)["username"] as! String
        self.ref = snapshot.ref
        self.key = snapshot.key
        
    }
    
    init(text: String, senderID: String, username: String) {
        self.key = ""
        self.ref = FIRDatabase.database().reference()
        self._text = text
        self._senderID = senderID
        self._username = username
    }
    
    func toAnyObject() -> [String: Any] {
        return ["text": text, "senderID": senderID, "username": username]
    }
    
    var text: String {
        get {
            return self._text
        }
        set (newText) {
            self._text = newText
        }
    }
    
    var senderID: String {
        get {
            return self._senderID
        }
        set (newSenderID) {
            self._senderID = newSenderID
        }
    }
    
    var username: String {
        get {
            return self._username
        }
        set (newUsername) {
            self._username = username
        }
    }
    
    
}
