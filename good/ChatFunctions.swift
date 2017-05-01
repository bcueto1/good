//
//  ChatFunctions.swift
//  good
//
//  Created by Brian Cueto on 3/18/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import Foundation
import Firebase

struct ChatFunctions {
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    func startChat(form: Form) {
        self.createChatroomID(chatroomID: form.postID)
    }
    
    func createChatroomID(chatroomID: String) {
        let chatRoomRef = databaseRef.child("chatrooms").queryOrdered(byChild: "chatroomID").queryEqual(toValue: chatroomID)
        chatRoomRef.observe(.value, with: { (snapshot) in
            var createChatroom = true
            
            if snapshot.exists() {
                
                if let values = snapshot.value as? [String: AnyObject] {
                    for chatRoom in values {
                        if (chatRoom.value as! NSDictionary)["chatroomID"] as? String  == chatroomID {
                            createChatroom = false
                        }
                    }
                }
            }
            
            if createChatroom {
                self.createNewChatroomID(chatroomID: chatroomID)
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
            
    }
    
    func createNewChatroomID(chatroomID: String) {
        
        let newChatRoom = ChatRoom(chatroomID: chatroomID)
        
        let chatRoomRef = databaseRef.child("chatrooms").child(chatroomID)
        chatRoomRef.setValue(newChatRoom.toAnyObject())
    }
    
    
    
}
