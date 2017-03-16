//
//  RoundLabel.swift
//  good
//
//  Created by Brian Cueto on 3/13/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit

class RoundLabel: UILabel {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 16
        layer.masksToBounds = true
        clipsToBounds = true
    }

}
