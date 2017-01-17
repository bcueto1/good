//
//  FormVC.swift
//  good
//
//  Created by Brian Cueto on 1/4/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit

class FormVC: UIViewController {
    
    var newForm = Form(myFormID: "formID")

    @IBOutlet weak var requestButton: AspectFitButton!
    @IBOutlet weak var offerButton: AspectFitButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func requestButtonTapped(_ sender: Any) {
        newForm.requestOrOffer = "Request"
        requestButton.alpha = 0.5
        offerButton.alpha = 1.0
    }
    
    @IBAction func offerButtonTapped(_ sender: Any) {
        newForm.requestOrOffer = "Offer"
        offerButton.alpha = 0.5
        requestButton.alpha = 1.0
    }
    @IBAction func typeOfGoodTapped(_ sender: Any) {
        
    }
    
    
    func enterName() {
        if nameTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter a valid name!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            newForm.firstName = nameTextField.text!
        }
    }
    
    func enterZipcode() {
        if zipcodeTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter a valid zipcode!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            newForm.zipcode = zipcodeTextField.text!
        }
    }
    
    
}
