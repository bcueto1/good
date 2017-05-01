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
import MobileCoreServices
import AVKit

class ChatVC: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var formID: String!
    var userFirstname: String!
    
    var messages = [JSQMessage]()
    
    let picker = UIImagePickerController();
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var userdataRef = UserDataService()

    override func viewDidLoad() {
        super.viewDidLoad()
            self.title = "MESSAGES"
        picker.delegate = self
        
        self.senderId = self.userdataRef.getCurrentUserId()
        self.senderDisplayName = userFirstname
        
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        let factory = JSQMessagesBubbleImageFactory()
        incomingBubbleImageView = factory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        outgoingBubbleImageView = factory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let messageQuery = databaseRef.child("chatrooms").child(self.formID).child("Messages").queryLimited(toLast: 100)
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
        
        //messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        
        let messageRef = databaseRef.child("chatrooms").child(self.formID).child("Messages").childByAutoId()
        let message = Message(text: text, senderID: senderId, username: senderDisplayName)
        
        
        messageRef.setValue(message.toAnyObject()) { (error, ref) in
            if error == nil {
                JSQSystemSoundPlayer.jsq_playMessageSentAlert()
            } else {
                print(error!.localizedDescription)
            }
        }
        
        collectionView.reloadData()
        
        finishSendingMessage()
        
    }
    
    /*
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let alert = UIAlertController(title: "Media Messages", message: "Please Select A Media", preferredStyle: .actionSheet);
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        
        let photos = UIAlertAction(title: "Photos", style: .default,    handler: { (alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeImage);
        })
        
        let videos = UIAlertAction(title: "Videos", style: .default,    handler: { (alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeMovie);
        })
        
        alert.addAction(photos);
        alert.addAction(videos);
        alert.addAction(cancel);
        present(alert, animated: true, completion: nil);
        
    }
    
    private func chooseMedia(type: CFString) {
        picker.mediaTypes = [type as String]
        present(picker, animated: true, completion: nil);
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let data = UIImageJPEGRepresentation(pic, 0.01);
            
            //MessagesHandler.Instance.sendMedia(image: data, video: nil, senderID: senderId, senderName: senderDisplayName);
            
        } else if let vidURL = info[UIImagePickerControllerMediaURL] as? URL {
            
            //MessagesHandler.Instance.sendMedia(image: nil, video: vidURL, senderID: senderId, senderName: senderDisplayName);
            
        }
        
        self.dismiss(animated: true, completion: nil);
        collectionView.reloadData();
    } */
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count;
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
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let msg = messages[indexPath.item];
        
        if msg.isMediaMessage {
            if let mediaItem = msg.media as? JSQVideoMediaItem {
                let player = AVPlayer(url: mediaItem.fileURL);
                let playerController = AVPlayerViewController();
                playerController.player = player;
                self.present(playerController, animated: true, completion: nil);
            }
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "propicDefault"), diameter: 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.row]
        
        if message.senderId == senderId {
            cell.textView.textColor = UIColor.black
        } else {
            cell.textView.textColor = UIColor.black
        }
        
        return cell
    }
    
    /*
    func messageReceived(senderID: String, senderName: String, text: String) {
        messages.append(JSQMessage(senderId: senderID, displayName: senderName, text: text));
        collectionView.reloadData();
    }
    
    func mediaReceived(senderID: String, senderName: String, url: String) {
        
        if let mediaURL = URL(string: url) {
            
            do {
                
                let data = try Data(contentsOf: mediaURL);
                
                if let _ = UIImage(data: data) {
                    
                    let _ = SDWebImageDownloader.shared().downloadImage(with: mediaURL, options: [], progress: nil, completed: { (image, data, error, finished) in
                        
                        DispatchQueue.main.async {
                            let photo = JSQPhotoMediaItem(image: image);
                            if senderID == self.senderId {
                                photo?.appliesMediaViewMaskAsOutgoing = true;
                            } else {
                                photo?.appliesMediaViewMaskAsOutgoing = false;
                            }
                            
                            self.messages.append(JSQMessage(senderId: senderID, displayName: senderName, media: photo));
                            self.collectionView.reloadData();
                            
                        }
                        
                    })
                    
                } else {
                    let video = JSQVideoMediaItem(fileURL: mediaURL, isReadyToPlay: true);
                    if senderID == self.senderId {
                        video?.appliesMediaViewMaskAsOutgoing = true;
                    } else {
                        video?.appliesMediaViewMaskAsOutgoing = false;
                    }
                    messages.append(JSQMessage(senderId: senderID, displayName: senderName, media: video));
                    self.collectionView.reloadData();
                    
                }
                
            } catch {
                // here we are gonna catch all potential errors that we get
            }
            
        }
        
    }
 */
    


}

extension ChatVC {
    
}
