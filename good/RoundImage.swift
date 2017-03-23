//
//  RoundImage.swift
//  good
//
//  Created by Brian Cueto on 12/29/16.
//  Copyright © 2016 Brian-good. All rights reserved.
//

import UIKit

class RoundImage: UIImageView {
    
    // Gets an image and makes it circular
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = false
        clipsToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
    }

}
