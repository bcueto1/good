//
//  MapVC.swift
//  good
//
//  Created by Brian Cueto on 1/4/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import SwiftKeychainWrapper

class MapVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                self.performSegue(withIdentifier: "goToSignIn", sender: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    


}
