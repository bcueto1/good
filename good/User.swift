//
//  User.swift
//  good
//
//  Created by Brian Cueto on 1/10/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import Foundation
import UIKit


class User {
    
    private var _firstName: String
    private var _rating: Double
    private var _points: Int
    private var _offers: Int
    private var _requests: Int
    private var _weeklyOffers: Int
    private var _weeklyRequests: Int
    private var _uid: String
    
    init(myFirstName: String, myUID: String) {
        _firstName = myFirstName
        _uid = myUID
        _rating = 0
        _points = 0
        _offers = 0
        _requests = 0
        _weeklyOffers = 0
        _weeklyRequests = 0
    }
    
    var uid: String {
        return _uid
    }
    
    var firstName: String {
        get {
            return _firstName
        }
        set (newFirstName) {
            _firstName = newFirstName
        }
    }
    
    var points: Int {
        get {
            return _points
        }
        set (newPoints) {
            _points = newPoints
        }
    }
    
    var offers: Int {
        get {
            return _offers
        }
        set (newOffers) {
            _offers = newOffers
        }
    }
    
    var requests: Int {
        get {
            return _requests
        }
        set (newRequests) {
            _requests = newRequests
        }
    }
    
    var weeklyOffers: Int {
        get {
            return _weeklyOffers
        }
        set (newWeeklyOffers) {
            _weeklyOffers = newWeeklyOffers
        }
    }
    
    var weeklyRequests: Int {
        get {
            return _weeklyRequests
        }
        set (newWeeklyRequests) {
            _weeklyRequests = newWeeklyRequests
        }
    }
    
}
