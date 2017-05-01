//
//  FormInfoVC.swift
//  good
//
//  Created by Brian Cueto on 4/24/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit

class FormInfoVC: UIViewController {
    
    @IBOutlet weak var requestButton: AspectFitButton!
    @IBOutlet weak var offerButton: AspectFitButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    
    var isRequest: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    /**
     * Handle functionality when request is tapped.
     *
     */
    @IBAction func requestButtonTapped(_ sender: Any) {
        self.requestButton.alpha = 0.5
        self.offerButton.alpha = 1.0
        self.isRequest = true
    }
    
    /**
     * Handle functionality when offer is tapped.
     *
     */
    @IBAction func offerButtonTapped(_ sender: Any) {
        self.offerButton.alpha = 0.5
        self.requestButton.alpha = 1.0
        self.isRequest = false
    }
    
    /**
     * Cancel button clears all values and returns user back to the map.
     *
     */
    @IBAction func cancelTapped(_ sender: Any) {
        self.resetValues()
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.takeToHome()
    }
    
    /**
     * Continue button first handles errors, then saves a new form to Firebase, then goes back to Map.
     *
     */
    @IBAction func continueTapped(_ sender: Any) {
        if self.handleErrors() {
            performSegue(withIdentifier: "formInfoToType", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "formInfoToType") {
            let typeController = segue.destination as! FormTypeVC
            typeController.name = self.nameTextField.text!
            typeController.zipcode = self.zipcodeTextField.text!
            typeController.isRequest = self.isRequest
        }
    }

}

extension FormInfoVC {
    
    /**
     * Calls all the error functions.
     *
     */
    func handleErrors() -> Bool {
        if (self.enterTypeOfForm() && self.enterName() && self.enterZipcode()) {
            return true
        }
        return false
    }
    
    /**
     * Throws an error if neither request nor offer were tapped.
     *
     */
    func enterTypeOfForm() -> Bool {
        if (self.requestButton.alpha == 1.0) && (self.offerButton.alpha == 1.0) {
            let alertController = UIAlertController(title: "Error", message: "Please select what you want!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    /**
     * Throws an error if no name was entered.
     *
     */
    func enterName() -> Bool {
        if self.nameTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter a valid name!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    /**
     * Throws an error if no zipcode was entered.
     *
     */
    func enterZipcode() -> Bool {
        if self.zipcodeTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter a valid zipcode!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    /**
     * Reset stuff.
     *
     */
    func resetValues() {
        self.nameTextField.text = ""
        self.zipcodeTextField.text = ""
        self.offerButton.alpha = 1.0
        self.requestButton.alpha = 1.0
    }

}
