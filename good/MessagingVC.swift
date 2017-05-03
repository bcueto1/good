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

/**
 * Shows the a segmented controller that divides request and offers.
 *
 */
class MessagingVC: UIViewController {
    
    /** Outlets */
    @IBOutlet weak var tableView: UITableView!
    
    var requestsArray = [Form]()
    var offersArray = [Form]()
    var selectedIndex: Int!
    var currentUserFirstName: String!
    
    /** Database reference */
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    /** Chat Functions reference */
    var chatFunctions = ChatFunctions()
    
    /**
     * Segemented control.  Used this to differentiate between offers and request tables.
     *
     */
    var segmentedControl: HMSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUserInfo()
        
        self.fetchAllUserPosts()
        self.setSegmentedControl()
    }
    
    
}

/**
 * Extension for MessagingVC that gives functionality to the segmented control and the table view.
 *
 */
extension MessagingVC: UITableViewDelegate, UITableViewDataSource {
    /**
     * Configures the segmented control.
     *
     */
    func setSegmentedControl() {
        self.segmentedControl = HMSegmentedControl(frame: CGRect(x: 0, y: 65, width: self.view.frame.size.width, height: 60))
        self.segmentedControl.sectionTitles = ["Requests", "Offers"]
        self.segmentedControl.backgroundColor = UIColor(red:0.20, green:0.40, blue:0.80, alpha:1.0)
        self.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0), NSFontAttributeName: UIFont(name:"Avenir-Heavy", size: 17)!]
        self.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.segmentedControl.selectionIndicatorColor = UIColor(red:1, green: 1, blue: 1, alpha: 0.5)
        self.segmentedControl.selectionStyle = .fullWidthStripe
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.selectionIndicatorLocation = .up
        self.segmentedControl.addTarget(self, action: #selector(MessagingVC.segmentedControlAction), for: UIControlEvents.valueChanged)
        self.view.addSubview(self.segmentedControl)
    }
    
    /**
     * Update the posts based on segmented control.
     *
     */
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormCell", for: indexPath) as! FormCell
            cell.configureCellForForm(form: offersArray[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormCell", for: indexPath) as! FormCell
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
     * When a row is selected, go to the chat stuff.
     *
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "messagesToChat", sender: nil)
    }
    
    /**
     * send relevant info to view conrollers based on segue.
     *
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "messagesToChat") {
            let chatController = segue.destination as! ChatParentVC
            if self.segmentedControl.selectedSegmentIndex == 0 {
                let chatForm = self.requestsArray[self.selectedIndex]
                chatController.formID = chatForm.postID
                chatController.userFirstName = self.currentUserFirstName
                self.chatFunctions.startChat(form: chatForm)
            } else {
                let chatForm = self.offersArray[self.selectedIndex]
                chatController.formID = chatForm.postID
                chatController.userFirstName = self.currentUserFirstName
                self.chatFunctions.startChat(form: chatForm)
            }
        }
    }
    
    
    /**
     * Fetches all the current users requests/offers.
     *
     */
    func fetchAllUserPosts() {
        let currentUser = FIRAuth.auth()!.currentUser!
        let formsRef = databaseRef.child("forms")

        //let userFormsRef = self.databaseRef.child("users").child(currentUser.uid).child("myForms")
        
        /*
        userFormsRef.observe(.value, with: { (snapshot) in
            var requestIDs = [String]()
            var offerIDs = [String]()
            var requestResultArray = [Form]()
            var offerResultArray = [Form]()
            
            
            let requests = (snapshot.value! as! NSDictionary)["myRequests"] as! [String : String]
            for rID in requests {
                requestIDs.append(rID.value)
            }
            for id in requestIDs {
                let formRef = self.databaseRef.child("forms").child(id)
                
                formRef.observe(.value, with: { (form) in
                    let newForm = Form(snapshot: form)
                    
                    requestResultArray.append(newForm)
                    self.requestsArray = requestResultArray
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            
            let offers = (snapshot.value! as! NSDictionary)["myOffers"] as! [String : String]
            for oID in offers {
                offerIDs.append(oID.value)
            }
            for id in offerIDs {
                let formRef = self.databaseRef.child("forms").child(id)
                
                formRef.observe(.value, with: { (form) in
                    let newForm = Form(snapshot: form)
                    
                    offerResultArray.append(newForm)
                    self.offersArray = offerResultArray
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        } */
        
        
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
    
    func loadUserInfo() {
        let currentUser = FIRAuth.auth()!.currentUser!
        let userRef = databaseRef.child("users").child(currentUser.uid)
        
        userRef.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let user = User(snapshot: currentUser)
            self.currentUserFirstName = user.firstName
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    
}
