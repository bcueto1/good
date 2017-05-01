//
//  AspectFitButton.swift
//  good
//
//  Created by Brian Cueto on 12/29/16.
//  Copyright © 2016 Brian-good. All rights reserved.
//

import UIKit

class AspectFitButton: UIButton {

    // Makes the button images aspect fit as well as create rounded corners
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.layer.cornerRadius = self.frame.width / 16
        clipsToBounds = true
    }
    
    func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func setBackgroundColor(color: UIColor, forUIControlState state: UIControlState) {
        self.setBackgroundImage(imageWithColor(color: color), for: state)
    }
}
