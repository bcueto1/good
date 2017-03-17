//
//  MessagingVC.swift
//  good
//
//  Created by Brian Cueto on 1/4/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit
import Firebase
import HMSegmentedControl

class MessagingVC: UIViewController {
    
    /** Outlets */
    @IBOutlet weak var tableView: UITableView!
    
    var requestsArray = [Form]()
    var offersArray = [Form]()
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    /**
     * Segemented control.  Used this to differentiate between offers and request tables.
     *
     */
    var segmentedControl: HMSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchAllUserPosts()
        self.setSegmentedControl()
    }
    
    
}

extension MessagingVC: UITableViewDelegate, UITableViewDataSource {
    /**
     * Configures the segmented control.
     *
     */
    func setSegmentedControl() {
        self.segmentedControl = HMSegmentedControl(frame: CGRect(x: 0, y: 65, width: self.view.frame.size.width, height: 60))
        self.segmentedControl.sectionTitles = ["Requests", "Offers"]
        self.segmentedControl.backgroundColor = UIColor(red:0.20, green:0.40, blue:0.80, alpha:1.0)
        self.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0), NSFontAttributeName: UIFont(name:"ChalkboardSE-Bold", size: 17)!]
        self.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.segmentedControl.selectionIndicatorColor = UIColor(red:1, green: 1, blue: 1, alpha: 0.5)
        self.segmentedControl.selectionStyle = .fullWidthStripe
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.selectionIndicatorLocation = .up
        self.segmentedControl.addTarget(self, action: #selector(MessagingVC.segmentedControlAction), for: UIControlEvents.valueChanged)
        self.view.addSubview(self.segmentedControl)
    }
    
    func segmentedControlAction() {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.fetchAllUserPosts()
            self.tableView.reloadData()
        } else {
            self.fetchAllUserPosts()
            self.tableView.reloadData()
        }
    }
    
    /**
     * Set the contents for each cell.
     *
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.segmentedControl.selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! FormCell
            cell.configureCellForForm(form: offersArray[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! FormCell
            cell.configureCellForForm(form: requestsArray[indexPath.row])
            return cell
        }
        
    }
    
    /**
     * Changes the selected color.
     *
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let view = UIView()
        view.backgroundColor = UIColor(red:1, green: 1, blue: 1, alpha: 0.75)
        cell.selectedBackgroundView = view
    }
    
    /**
     * Determines the number of rows for the table view.
     *
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            rows = requestsArray.count
        case 1:
            rows = offersArray.count
        default:
            break
        }
        return rows
    }
    
    /**
     * Determines the row height for the table view.
     *
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        if self.segmentedControl.selectedSegmentIndex == 1 {
            height = 150
        } else {
            height = 150
        }
        return height
    }
    
    
    /**
     * Fetches all the current users requests/offers.  Will optimize this later.
     *
     */
    func fetchAllUserPosts() {
        let currentUser = FIRAuth.auth()!.currentUser!
        let formsRef = databaseRef.child("forms")
        //let requestsRef = databaseRef.child("users").child(currentUser.uid).child("myForms").child("myRequests")
        //let offersRef = databaseRef.child("users").child(currentUser.uid).child("myForms").child("myOffers")
        
        formsRef.observe(.value, with: { (forms) in
            var requestResultArray = [Form]()
            var offerResultArray = [Form]()
            for form in forms.children {
                let newForm = Form(snapshot: form as! FIRDataSnapshot)
                
                if ((newForm.submitterUID == currentUser.uid) && (newForm.takerUID != "")) {
                    if newForm.request {
                        requestResultArray.append(newForm)
                    } else {
                        offerResultArray.append(newForm)
                    }
                } else if (newForm.takerUID == currentUser.uid) {
                    if newForm.request {
                        offerResultArray.append(newForm)
                    } else {
                        requestResultArray.append(newForm)
                    }
                }
            }
            
            self.requestsArray = requestResultArray
            self.offersArray = offerResultArray
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}
