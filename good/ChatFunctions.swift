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
        let usersRef = self.databaseRef.child("users")
        let submitterRef = usersRef.child(form.submitterUID)
        let takerRef = usersRef.child(form.takerUID)
        submitterRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let submitter = User(snapshot: snapshot)
            takerRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let taker = User(snapshot: snapshot)
                let members = [submitter.firstName, taker.firstName]
                self.createChatRoomID(user1: submitter, user2: taker, members: members, chatRoomID: form.postID)
            }) { (error) in
                print(error.localizedDescription)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
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
        
        let newChatRoom = ChatRoom(username: username, otherUsername: otherUsername, userID: userID, otherID: otherID, formID: chatRoomID, members: members, chatRoomID: chatRoomID, lastMessage: lastMessage, userPhotoURL: userPhotoURL, otherPhotoURL: otherPhotoURL)
        
        let chatRoomRef = databaseRef.child("ChatRooms").child(chatRoomID)
        chatRoomRef.setValue(newChatRoom.toAnyObject())
    }
    
    
    
}
