//
//  ProfileVC.swift
//  good
//
//  Created by Brian Cueto on 1/4/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit
import Firebase

/**
 * View controller that displays the current user's profile.
 *
 */
class ProfileVC: UIViewController {

    /** Outlets */
    @IBOutlet weak var profilePicture: RoundImage!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var myPoints: UILabel!
    @IBOutlet weak var yourWeeklyOffers: UILabel!
    @IBOutlet weak var yourWeeklyRequests: UILabel!
    @IBOutlet weak var yourOffers: UILabel!
    @IBOutlet weak var yourRequests: UILabel!
    @IBOutlet weak var settingsButton: AspectFitButton!
    
    /** Rating */
    private var myRating: Double!
    
    /** database reference */
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    /**
     * Automatically load user info when view appears on screen.
     *
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.loadUserInfo()
        self.handleRating()
    }

    /**
     * Go to settings VC.
     *
     */
    @IBAction func settingsTapped(_ sender: Any) {
        performSegue(withIdentifier: "profileToSettings", sender: nil)
    }
    
    /**
     * Loads the user info base on the uid by getting the current user.
     * User struct initialized and then updates the profile.
     *
     */
    func loadUserInfo() {
        let currentUser = FIRAuth.auth()!.currentUser!
        let userRef = dataBaseRef.child("users").child(currentUser.uid)

        userRef.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let user = User(snapshot: currentUser)
            self.firstName.text = user.firstName
            self.myPoints.text = String(user.points)
            self.myRating = user.rating as Double!
            self.yourOffers.text = String(user.offers)
            self.yourRequests.text = String(user.requests)
            self.yourWeeklyOffers.text = String(user.weeklyOffers)
            self.yourWeeklyRequests.text = String(user.weeklyRequests)

            
            self.downloadImageFromFirebase(urlString: user.profilePicURL)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    /**
     * Downloads the user profile picture from the Firebase Storage.
     *
     */
    func downloadImageFromFirebase(urlString: String) {
        let storageRef = FIRStorage.storage().reference(forURL: urlString)
        storageRef.data(withMaxSize: 1 * 1024 * 1024) { (imageData, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if let data = imageData {
                    DispatchQueue.main.async(execute: {
                        self.profilePicture.image = UIImage(data: data)
                    })
                }
            }
        }
    }
    
    /** Handle functionality for putting stars for rating. */
    func handleRating() {
        
    }

}
