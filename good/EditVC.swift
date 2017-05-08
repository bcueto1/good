//
//  EditVC.swift
//  good
//
//  Created by Brian Cueto on 5/7/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit
import Firebase

class EditVC: UIViewController {
    
    var formID: String!
    var currentForm: Form!
    
    /** Reference to database */
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var formDataService = FormDataService()
    var userDataService = UserDataService()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var specificTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var requestButton: AspectFitButton!
    @IBOutlet weak var offerButton: AspectFitButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let form = self.currentForm
        let currentUser = FIRAuth.auth()!.currentUser!
        
        if (self.nameTextField.text != "") {
            self.formDataService.changeFirstname(form: form!, name: nameTextField.text!)
        }
        if (self.zipcodeTextField.text != "") {
            self.formDataService.changeZipcode(form: form!, zipcode: zipcodeTextField.text!)
        }
        if (self.typeTextField.text != "") {
            self.formDataService.changeType(form: form!, type: typeTextField.text!)
        }
        if (self.specificTextField.text != "") {
            self.formDataService.changeSpecific(form: form!, specific: specificTextField.text!)
        }
        if (self.messageTextField.text != "") {
            self.formDataService.changeMessage(form: form!, message: messageTextField.text!)
        }
        
        if ((self.requestButton.alpha == 0.5) && (!(form?.request)!)) {
            self.formDataService.changeRequestType(form: form!, request: true)
            self.userDataService.removeOfferForm(userID: (form?.submitterUID)!, form: form!)
            self.userDataService.addNewRequestForm(user: currentUser, form: form!)
        }
        if ((self.offerButton.alpha == 0.5) && ((form?.request)!)) {
            self.formDataService.changeRequestType(form: form!, request: false)
            self.userDataService.removeRequestForm(userID: (form?.submitterUID)!, form: form!)
            self.userDataService.addNewOfferForm(user: currentUser, form: form!)
        }
        
        
        performSegue(withIdentifier: "editToForm", sender: nil)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        let form = self.currentForm
        
        if (form?.request)! {
            self.userDataService.removeRequestForm(userID: (form?.submitterUID)!, form: form!)
        } else {
            self.userDataService.removeOfferForm(userID: (form?.submitterUID)!, form: form!)
        }
        
        self.formDataService.deleteForm(form: form!)
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.takeToHome()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        performSegue(withIdentifier: "editToForm", sender: nil)
    }
    
    @IBAction func requestButtonTapped(_ sender: Any) {
        self.requestButton.alpha = 0.5
        self.offerButton.alpha = 1.0
    }
    
    @IBAction func offerButtonTapped(_ sender: Any) {
        self.requestButton.alpha = 1.0
        self.offerButton.alpha = 0.5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editToForm" {
            let infoVC = segue.destination as? MapFormVC
            infoVC?.formID = self.formID
        }
    }
    

}
