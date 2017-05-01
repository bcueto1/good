//
//  FormVC.swift
//  good
//
//  Created by Brian Cueto on 1/4/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class FormVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {

    /** Outlets */
    @IBOutlet weak var requestButton: AspectFitButton!
    @IBOutlet weak var offerButton: AspectFitButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var typeOfGoodField: UITextField!
    @IBOutlet weak var typeDropdown: UIPickerView!
    @IBOutlet weak var cancelButton: AspectFitButton!
    @IBOutlet weak var confirmButton: AspectFitButton!
    
    /** Variables */
    var good : String = ""
    var isRequest : Bool = false
    var latitude: NSNumber = 0.0
    var longitude: NSNumber = 0.0
    
    /** Form service */
    var formService = FormDataService()
    
    var locationManager = CLLocationManager()
    var myLocation = CLLocationCoordinate2D()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        
        // Startup for map
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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
            formService.createNewForm(request: self.isRequest, type: self.typeOfGoodField.text!, firstName: self.nameTextField.text!, zipcode: self.zipcodeTextField.text!, message: self.messageTextView.text!, latitude: self.latitude, longitude: self.longitude)
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.takeToHome()
        }
    }
    
}


/**
 * Extention for FormVC including error handling functions as well as pickerView functions.
 *
 */
extension FormVC {
    
    /**
     * Get the current location and set the span of the region.
     *
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location updated")
        
        self.myLocation = (manager.location?.coordinate)!
        locationManager.stopUpdatingLocation()
        let coordinations = CLLocationCoordinate2D(latitude: self.myLocation.latitude ,longitude: self.myLocation.longitude)
        self.latitude = Double(coordinations.latitude) as NSNumber
        self.longitude = Double(coordinations.longitude) as NSNumber
        
    }
    
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
        let countRows: Int = goods.count

        
        return countRows
    }
    
    /**
     * Handles the title of each row after selection.
     *
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == typeDropdown {
            
            let titleRow = goods[row]
            return titleRow
        }

        return ""
    }
    
    /**
     * After person is done selecting stuff, then the next stuff will appear.
     *
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == typeDropdown {
            self.typeOfGoodField.text = goods[row]
            self.good = goods[row]
            self.typeDropdown.isHidden = true
            
        }

    }
    
    /**
     * If a person started selecting the text fields, do stuff.
     *
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.typeOfGoodField) {
            self.typeDropdown.isHidden = false

        }

    }
    
    /**
     * Calls all the error functions.
     *
     */
    func handleErrors() -> Bool {
        if (self.enterTypeOfForm() && self.enterName() && self.enterZipcode() && self.enterMessage() && self.enterType()) {
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
     * Throws an error if no message was entered.
     *
     */
    func enterMessage() -> Bool {
        if self.messageTextView.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter a message!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    /**
     * Throws an error if no type was entered.
     *
     */
    func enterType() -> Bool {
        if self.typeOfGoodField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter a type of service!", preferredStyle: .alert)
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
        self.messageTextView.text = ""
        self.typeOfGoodField.text = ""
        self.offerButton.alpha = 1.0
        self.requestButton.alpha = 1.0
        self.good = ""
        self.latitude = 0.0
        self.longitude = 0.0
    }
}
