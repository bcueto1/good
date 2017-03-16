//
//  UIViewControllerExtentions.swift
//  good
//
//  Created by Brian Cueto on 12/30/16.
//  Copyright © 2016 Brian-good. All rights reserved.
//

import UIKit

/**
 * Extension for the UIViewControllers
 *
 */
extension UIViewController {
    
    /**
     * Hides the keyboard whenever someone taps outside of the boundaries.
     *
     */
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    /**
     * Dismisses keyboard.
     *
     */
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
