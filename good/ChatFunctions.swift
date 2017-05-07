//
//  ChatFunctions.swift
//  good
//
//  Created by Brian Cueto on 3/18/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import Foundation
import Firebase

/**
 * ChatFunctions Struct for handling creating messages
 *
 */
struct ChatFunctions {
    
    /** database reference */
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    /**
     * Parent function for retrieving/starting a new chat room.
     *
     */
    func startChat(form: Form) {
        self.createChatroomID(chatroomID: form.postID)
    }
    
    /**
     * Creates a chatroom ID.  If one already exists, just retrieve the chatroom.
     *
     */
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
    
    /**
     * Creates a new chatroom id if none existed prior.
     *
     */
    func createNewChatroomID(chatroomID: String) {
        
        let newChatRoom = ChatRoom(chatroomID: chatroomID)
        
        let chatRoomRef = databaseRef.child("chatrooms").child(chatroomID)
        chatRoomRef.setValue(newChatRoom.toAnyObject())
    }
    
    
    
}
