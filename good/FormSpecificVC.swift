//
//  FormSpecificVC.swift
//  good
//
//  Created by Brian Cueto on 4/24/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit

class FormSpecificVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var name: String!
    var zipcode: String!
    var type: String!
    var isRequest: Bool!
    var specific: String!
    
    @IBOutlet weak var specificTextField: UITextField!
    @IBOutlet weak var specificDropdown: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.checkType()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.takeToHome()
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        if self.handleErrors() {
            performSegue(withIdentifier: "formSpecificToEnter", sender: nil)
        }
    }
    
    func checkType() {
        if (self.type == "housing" || self.type == "food"
            || self.type == "rides" || self.type == "gathering") {
            
            if (self.type == "housing") {
                self.specific = "housing offered"
            } else if (self.type == "food") {
                self.specific = "food offered"
            } else if (self.type == "rides") {
                self.specific = "car"
            } else if (self.type == "gathering") {
                self.specific = "gathering"
            }
            
            performSegue(withIdentifier: "formSpecificToEnter", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "formSpecificToEnter") {
            let enterVC = segue.destination as? FormEnterVC
            enterVC?.name = self.name
            enterVC?.zipcode = self.zipcode
            enterVC?.isRequest = self.isRequest
            enterVC?.type = self.type
            enterVC?.specific = self.specific
        } else if (segue.identifier == "formSpecificToType") {
            let typeVC = segue.destination as? FormTypeVC
            typeVC?.name = self.name
            typeVC?.zipcode = self.zipcode
            typeVC?.isRequest = self.isRequest
            
        }
    }

}

extension FormSpecificVC {

    /**
     * How many components in the pickerView.
     *
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /**
     * Returns number of rows in pickerView based on type of dropdown.
     *
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countRows: Int = 0
        
        if (self.type == "friendship") {
            countRows = friendshipArray.count
        } else if (self.type == "service") {
            countRows = servicesArray.count
        }
        
        
        return countRows
    }
    
    /**
     * Handles the title of each row after selection.
     *
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.type == "friendship" {
            
            let titleRow = friendshipArray[row]
            return titleRow
        } else if self.type == "service" {
            let titleRow = servicesArray[row]
            return titleRow
        }
        
        return ""
    }
    
    /**
     * After person is done selecting stuff, then the next stuff will appear.
     *
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.type == "friendship" {
            self.specificTextField.text = friendshipArray[row]
            self.specific = friendshipArray[row]
            self.specificDropdown.isHidden = true
            
        } else if self.type == "service" {
            self.specificTextField.text = servicesArray[row]
            self.specific = servicesArray[row]
            self.specificDropdown.isHidden = true
        }
        
    }
    
    /**
     * If a person started selecting the text fields, do stuff.
     *
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.specificTextField) {
            self.specificDropdown.isHidden = false
            
        }
        
    }
    
    /**
     * Handle errors.
     *
     */
    func handleErrors() -> Bool {
        if (self.specific == "") {
            let alertController = UIAlertController(title: "Error", message: "Please enter details!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }

}
