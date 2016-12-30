//
//  RoundImage.swift
//  good
//
//  Created by Brian Cueto on 12/29/16.
//  Copyright © 2016 Brian-good. All rights reserved.
//

import UIKit

class RoundImage: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
        layer.masksToBounds = true
        clipsToBounds = true
    }

}
