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
    
    var _chatroomID: String!
    var ref: FIRDatabaseReference!
    var key: String = ""
    
    init(snapshot: FIRDataSnapshot) {
        self._chatroomID = (snapshot.value! as! NSDictionary)["chatroomID"] as! String
        self.ref = snapshot.ref
        self.key = snapshot.key
    }
    
    init(chatroomID: String) {
        self._chatroomID = chatroomID
    }
    
    func toAnyObject() -> [String: Any] {
        return ["chatroomID": chatroomID]
    }
    
    
    /** Getters and Setters. */
    
    var chatroomID: String {
        return self._chatroomID
    }
    
    
}
