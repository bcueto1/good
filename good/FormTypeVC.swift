//
//  FormTypeVC.swift
//  good
//
//  Created by Brian Cueto on 4/24/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit

class FormTypeVC: UIViewController {
    
    var name: String = ""
    var zipcode: String = ""
    var isRequest: Bool = false
    var type: String = ""
    
    @IBOutlet weak var friendshipButton: AspectFitButton!
    @IBOutlet weak var housingButton: AspectFitButton!
    @IBOutlet weak var ridesButton: AspectFitButton!
    @IBOutlet weak var serviceButton: AspectFitButton!
    @IBOutlet weak var foodButton: AspectFitButton!
    @IBOutlet weak var gatheringButton: AspectFitButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

    }
    
    @IBAction func friendshipButtonTapped(_ sender: Any) {
        self.type = "friendship"
        self.setAlphaToOne()
        self.friendshipButton.alpha = 0.5
    }
    
    @IBAction func housingButtonTapped(_ sender: Any) {
        self.type = "housing"
        self.setAlphaToOne()
        self.housingButton.alpha = 0.5
    }
    
    @IBAction func ridesButtonTapped(_ sender: Any) {
        self.type = "rides"
        self.setAlphaToOne()
        self.ridesButton.alpha = 0.5
    }
    
    @IBAction func serviceButtonTapped(_ sender: Any) {
        self.type = "service"
        self.setAlphaToOne()
        self.serviceButton.alpha = 0.5
    }
    
    @IBAction func foodButtonTapped(_ sender: Any) {
        self.type = "food"
        self.setAlphaToOne()
        self.foodButton.alpha = 0.5
    }
    
    @IBAction func gatheringButtonTapped(_ sender: Any) {
        self.type = "gathering"
        self.setAlphaToOne()
        self.gatheringButton.alpha = 0.5
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        if self.handleErrors() {
            performSegue(withIdentifier: "formTypeToSpecific", sender: nil)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.setAlphaToOne()
        self.type = ""
        self.name = ""
        self.zipcode = ""
        self.isRequest = false
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.takeToHome()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        performSegue(withIdentifier: "formTypeToInfo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "formTypeToSpecific") {
            let specificVC = segue.destination as? FormSpecificVC
            specificVC?.name = name
            specificVC?.zipcode = zipcode
            specificVC?.isRequest = isRequest
            specificVC?.type = type
        }
    }

}

extension FormTypeVC {
    
    func setAlphaToOne() {
        self.friendshipButton.alpha = 1.0
        self.housingButton.alpha = 1.0
        self.ridesButton.alpha = 1.0
        self.serviceButton.alpha = 1.0
        self.foodButton.alpha = 1.0
        self.gatheringButton.alpha = 1.0
    }
    
    func handleErrors() -> Bool {
        if (self.type == "") {
            let alertController = UIAlertController(title: "Error", message: "Please enter type!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
}
