//
//  Coordinate.swift
//  good
//
//  Created by Brian Cueto on 3/14/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import Foundation

/**
 * Struct of coordinate.  Also has a hash value for the map view to link to specific form.
 *
 */
struct Coordinate: Hashable {
    /** Private variables */
    private var _latitude: NSNumber
    private var _longitude: NSNumber
    
    /**
     * Initializer
     *
     */
    init(latitude: NSNumber, longitude: NSNumber) {
        self._latitude = latitude
        self._longitude = longitude
    }
    
    /** Getters and Setters */
    var latitude: NSNumber {
        get {
            return self._latitude
        }
        set (newLatitude) {
            self._latitude = newLatitude
        }
    }
    
    var longitude: NSNumber {
        get {
            return self._longitude
        }
        set (newLongitude) {
            self._longitude = newLongitude
        }
    }
    
    /**
     * Return the hash value of the coordinate determined by the latitude and longitude.
     */
    var hashValue: Int {
        return "\(String(describing: self.latitude)),\(String(describing: self.longitude))".hashValue
    }
    
    /**
     *  Used to compare values between different coordinates so it can be hashable.
     */
    static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
