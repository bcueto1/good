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
        self.type = "food"
        self.setAlphaToOne()
        self.gatheringButton.alpha = 0.5
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        
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
    
}
