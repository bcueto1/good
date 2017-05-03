//
//  DoneGoodVC.swift
//  good
//
//  Created by Brian Cueto on 5/3/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit
import Firebase
import Cosmos

/**
 * View controller to give a rating to a person and confirm
 * a task is done.
 *
 */
class DoneGoodVC: UIViewController {
    
    var formID: String!
    var currentUserName: String!
    var otherUser: User!
    
    /** Database Reference */
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    /** User data service reference */
    var userDataService = UserDataService()

    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var enterButton: AspectFitButton!
    
    /**
     * Configure star view when view loads.
     *
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        starView.rating = 0.0
        starView.settings.updateOnTouch = true
    }
    
    /**
     * If enter button tapped, add rating and update form, then go back to map.
     *
     */
    @IBAction func enterButtonTapped(_ sender: Any) {
        self.userDataService.addRating(user: self.otherUser, rating: starView.rating)
        self.updateForm()
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.takeToHome()
    }
    
    /**
     * Sends info back to the info view controller.
     *
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "doneToInfo") {
            let infoVC = segue.destination as? SocialInfoVC
            infoVC?.formID = self.formID
            infoVC?.currentUserFirstName = self.currentUserName
        }
    }
    
    /**
     * Updates form based on when people enter ratings.
     *
     */
    func updateForm() {
        let formRef = self.databaseRef.child("forms").child(self.formID)
        let currentUser = FIRAuth.auth()?.currentUser
        
        formRef.observe(.value, with: { (formSnapshot) in
            var form = Form(snapshot: formSnapshot)
            if (form.submitterUID == currentUser?.uid) {
                formRef.child("doneBySubmitter").setValue(true)
                form.doneBySubmitter = true
            } else if (form.takerUID == currentUser?.uid) {
                formRef.child("doneByTaker").setValue(true)
                form.doneByTaker = true
            }
            
            if (form.doneBySubmitter && form.doneByTaker) {
                formRef.child("completed").setValue(true)
                
                if (form.request) {
                    if (form.submitterUID == currentUser?.uid) {
                        self.userDataService.addPoints(points: 1)
                    } else {
                        self.userDataService.addPoints(user: self.otherUser, points: 1)
                    }
                } else {
                    if (form.submitterUID == currentUser?.uid) {
                        self.userDataService.addPoints(user: self.otherUser, points: 1)
                    } else {
                        self.userDataService.addPoints(points: 1)
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    
    

}
