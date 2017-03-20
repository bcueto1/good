//
//  ChatVC.swift
//  good
//
//  Created by Brian Cueto on 1/17/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatVC: JSQMessagesViewController {
    
    var chatRoomID: String!
    
    var messages = [JSQMessage]()
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
            self.title = "MESSAGES"
        let factory = JSQMessagesBubbleImageFactory()
        
        incomingBubbleImageView = factory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        outgoingBubbleImageView = factory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let messageQuery = databaseRef.child("ChatRooms").child(chatRoomID).child("Messages").queryLimited(toLast: 30)
        messageQuery.observe(.childAdded, with: { (snapshot) in
            let senderID = (snapshot.value! as! NSDictionary)["senderID"] as! String
            let text = (snapshot.value! as! NSDictionary)["text"] as! String
            let displayName = (snapshot.value! as! NSDictionary)["username"] as! String
            self.addMessage(text: text, senderID: senderID, displayName: displayName)
            self.finishReceivingMessage()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addMessage(text: String, senderID: String, displayName: String) {
        let message = JSQMessage(senderId: senderID, displayName: displayName, text: text)
        messages.append(message!)
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let messageRef = databaseRef.child("ChatRooms").child(chatRoomID).child("Messages").childByAutoId()
        let message = Message(text: text, senderID: senderId, username: senderDisplayName)
        
        messageRef.setValue(message.toAnyObject()) { (error, ref) in
            if error == nil {
                JSQSystemSoundPlayer.jsq_playMessageSentAlert()
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.row]
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.row]
        
        if message.senderId == senderId {
            cell.textView.textColor = UIColor.white
        } else {
            cell.textView.textColor = UIColor.black
        }
        
        return cell
    }

}

extension ChatVC {
    
}
