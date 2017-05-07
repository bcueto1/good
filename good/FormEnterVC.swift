//
//  FormEnterVC.swift
//  good
//
//  Created by Brian Cueto on 4/24/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class FormEnterVC: UIViewController, CLLocationManagerDelegate {
    
    var name: String!
    var zipcode: String!
    var type: String!
    var specific: String!
    var isRequest: Bool!
    var latitude: NSNumber!
    var longitude: NSNumber!
    
    var formService = FormDataService()
    
    var locationManager = CLLocationManager()
    var myLocation = CLLocationCoordinate2D()

    @IBOutlet weak var messageTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Startup for map
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func enterButtonTapped(_ sender: Any) {
        
        if handleErrors() {
            self.formService.createNewForm(request: self.isRequest, type: self.type, specific: self.specific, firstName: self.name, zipcode: self.zipcode, message: self.messageTextView.text, latitude: self.latitude, longitude: self.longitude)
            
            
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.takeToHome()
        }
        
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.takeToHome()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "formEnterToSpecific") {
            let specificVC = segue.destination as? FormSpecificVC
            specificVC?.name = self.name
            specificVC?.zipcode = self.zipcode
            specificVC?.type = self.type
            specificVC?.isRequest = self.isRequest
        }
    }

}

extension FormEnterVC {
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
     * Handle Errors.
     *
     */
    func handleErrors() -> Bool {
        if self.messageTextView.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter a message!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    

}
