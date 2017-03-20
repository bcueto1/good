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
    
    var thisChatRoomID = String()
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    mutating func startChat(user1: User, user2: User) {
        let userID1 = user1.uid
        let userID2 = user2.uid
        
        var tempID = ""
        
        let comparison = userID1.compare(userID2).rawValue
        
        let members = [user1.firstName, user2.firstName]
        
        if comparison < 0 {
            tempID = userID1.appending(userID2)
        } else {
            tempID = userID2.appending(userID1)
        }
        
        self.thisChatRoomID = tempID
        self.createChatRoomID(user1: user1, user2: user2, members: members, chatRoomID: tempID)
        
    }
    
    func createChatRoomID(user1: User, user2: User, members: [String], chatRoomID: String) {
        let chatRoomRef = databaseRef.child("ChatRooms").queryOrdered(byChild: "chatRoomID").queryEqual(toValue: chatRoomID)
        chatRoomRef.observe(.value, with: { (snapshot) in
            var createChatRoom = true
            
            if snapshot.exists() {
                
                if let values = snapshot.value as? [String: AnyObject] {
                    for chatRoom in values {
                        //if let chatRoomID = chatRoom.value["chatRoomID"] as? String
                        if (chatRoom.value as! NSDictionary)["chatRoomID"] as? String  == chatRoomID {
                            createChatRoom = false
                        }
                    }
                }
            }
            
            if createChatRoom {
                self.createNewChatRoomID(username: user1.firstName, otherUsername: user2.firstName, userID: user1.uid, otherID: user2.uid, members: members, chatRoomID: chatRoomID, lastMessage: "", userPhotoURL: user1.profilePicURL, otherPhotoURL: user2.profilePicURL)
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
            
    }
    
    func createNewChatRoomID(username: String, otherUsername: String, userID: String, otherID: String, members: [String], chatRoomID: String, lastMessage: String, userPhotoURL: String, otherPhotoURL: String) {
        
        let newChatRoom = ChatRoom(username: username, otherUsername: otherUsername, userID: userID, otherID: otherID, members: members, chatRoomID: chatRoomID, lastMessage: lastMessage, userPhotoURL: userPhotoURL, otherPhotoURL: otherPhotoURL)
        
        let chatRoomRef = databaseRef.child("ChatRooms").child(chatRoomID)
        chatRoomRef.setValue(newChatRoom.toAnyObject())
    }
    
    
    
}
