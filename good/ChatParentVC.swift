//
//  ChatParentVC.swift
//  good
//
//  Created by Brian Cueto on 4/27/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit

/**
 * Parent class for the chat controller.
 *
 */
class ChatParentVC: UIViewController {
    
    var formID: String!
    var userFirstName: String!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "parentToChat") {
            let chatController = segue.destination as! ChatVC
            chatController.formID = self.formID
            chatController.userFirstname = self.userFirstName
        }
        if (segue.identifier == "parentToInfo") {
            let infoController = segue.destination as! SocialInfoVC
            infoController.formID = self.formID
        }
    }

}
