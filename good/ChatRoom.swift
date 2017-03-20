//
//  ChatRoom.swift
//  good
//
//  Created by Brian Cueto on 3/17/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import Foundation
import Firebase

struct ChatRoom {
    
    var _username: String!
    var _otherUsername: String!
    var _userID: String!
    var _otherID: String!
    var _members: [String]!
    var _chatRoomID: String!
    var _lastMessage: String!
    var _userPhotoURL: String!
    var _otherPhotoURL: String!
    var ref: FIRDatabaseReference!
    var key: String = ""
    
    init(snapshot: FIRDataSnapshot) {
        self._username = (snapshot.value! as! NSDictionary)["username"] as! String
        self._otherUsername = (snapshot.value! as! NSDictionary)["otherUsername"] as! String
        self._userID = (snapshot.value! as! NSDictionary)["userID"] as! String
        self._otherID = (snapshot.value! as! NSDictionary)["otherID"] as! String
        self._members = (snapshot.value! as! NSDictionary)["members"] as! [String]
        self._chatRoomID = (snapshot.value! as! NSDictionary)["chatRoomID"] as! String
        self._lastMessage = (snapshot.value! as! NSDictionary)["lastMessage"] as! String
        self._userPhotoURL = (snapshot.value! as! NSDictionary)["userPhotoURL"] as! String
        self._otherPhotoURL = (snapshot.value! as! NSDictionary)["otherPhotoURL"] as! String
        self.ref = snapshot.ref
        self.key = snapshot.key
    }
    
    init(username: String, otherUsername: String, userID: String, otherID: String, members: [String], chatRoomID: String, lastMessage: String, userPhotoURL: String, otherPhotoURL: String) {
        self._username = username
        self._otherUsername = otherUsername
        self._userID = userID
        self._otherID = otherID
        self._members = members
        self._chatRoomID = chatRoomID
        self._lastMessage = lastMessage
        self._userPhotoURL = userPhotoURL
        self._otherPhotoURL = otherPhotoURL
    }
    
    func toAnyObject() -> [String: Any] {
        return ["username": username, "otherUsername": otherUsername, "userID": userID, "otherID": otherID, "members": members, "chatRoomID": chatRoomID, "lastMessage": lastMessage, "userPhotoURL": userPhotoURL, "otherPhotoURL": otherPhotoURL]
    }
    
    
    /** Getters and Setters. */
    var username: String {
        return self._username
    }
    
    var otherUsername: String {
        return self._otherUsername
    }
    
    var userID: String {
        return self._userID
    }
    
    var otherID: String {
        return self._otherID
    }
    
    var members: [String] {
        return self._members
    }
    
    var chatRoomID: String {
        return self._chatRoomID
    }
    
    var lastMessage: String {
        return self._lastMessage
    }
    
    var userPhotoURL: String {
        return self._userPhotoURL
    }
    
    var otherPhotoURL: String {
        return self._otherPhotoURL
    }
    
    
}
