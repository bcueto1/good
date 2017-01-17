//
//  Form.swift
//  good
//
//  Created by Brian Cueto on 1/14/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import Foundation
import UIKit

struct Form {
    
    private var _requestOrOffer: String
    private var _typeOfGood: String
    private var _specificDeed: String
    private var _pointsAllocated: Int
    private var _firstName: String
    private var _zipcode: String
    private var _message: String
    private var _formID: String
    
    init(myFormID: String) {
        _requestOrOffer = ""
        _typeOfGood = ""
        _specificDeed = ""
        _pointsAllocated = 0
        _firstName = ""
        _zipcode = ""
        _message = ""
        _formID = myFormID
    }
    
    var formID: String {
        get {
            return _formID
        }
    }
    
    var requestOrOffer: String {
        get {
            return _requestOrOffer
        }
        set (changeRequest) {
            _requestOrOffer = changeRequest
        }
    }
    
    var specificDeed: String {
        get {
            return _specificDeed
        }
        set (newSpecificDeed) {
            _specificDeed = newSpecificDeed
        }
    }
    
    var pointsAllocated: Int {
        get {
            return _pointsAllocated
        }
        set (newPointsAllocated) {
            _pointsAllocated = newPointsAllocated
        }
    }
    
    var firstName: String {
        get {
            return _firstName
        }
        set (newFirstName) {
            _firstName = newFirstName
        }
    }
    
    var zipcode: String {
        get {
            return _zipcode
        }
        set (newZipCode) {
            _zipcode = newZipCode
        }
    }
    
    var message: String {
        get {
            return _message
        }
        set (newMessage) {
            _message = newMessage
        }
    }
}
