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
        layer.cornerRadius = self.frame.width / 16
        layer.masksToBounds = true
        clipsToBounds = true
    }
}
