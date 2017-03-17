//
//  MapVC.swift
//  good
//
//  Created by Brian Cueto on 1/4/17.
//  Copyright © 2017 Brian-good. All rights reserved.
//

import UIKit
import CoreLocation
import CoreTelephony
import Firebase
import MapKit

/**
 * Displays a map where user can see active requests/offers.
 *
 */
class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    /** Outlets */
    @IBOutlet weak var mapView: MKMapView!
    
    /** Array of forms */
    var formArray = [Form]()
    /** Dictionary with coordinate values and forms */
    var coordFormDict = [Coordinate: Form]()

    /** Form Data Service */
    var formService = FormDataService()
    /** User Data Service */
    var userService = UserDataService()
    /** Reference to database */
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    /** Location stuff */
    var locationManager = CLLocationManager()
    var myLocation = CLLocationCoordinate2D()

    /**
     * When view loads, load all the location/map settings.  Retrieve the forms from Firebase.  ALlow Firebase messaging.
     *
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Startup for map
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Retrieve annotations for the forms
        self.retrieveForms()
        
        // Allows for notifications
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
    }
    
    /**
     * When the view appears, create annoations.
     *
     */
    override func viewDidAppear(_ animated: Bool) {
        self.createAnnotations()
    }
    
}

/**
 * Extention for MapVC with functionality for location manager.
 *
 */
extension MapVC {
    
    /**
     * Edits the annotation view.
     *
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView Id")
        
        if annotation is MKUserLocation {
            return nil
        }
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView Id")
            view!.canShowCallout = true
        } else {
            view!.annotation = annotation
        }
        
        view?.leftCalloutAccessoryView = nil
        view?.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
        
        return view
    }
    
    /**
     * Handles when the button on the annotation is tapped.
     *
     */
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control as? UIButton)?.buttonType == UIButtonType.detailDisclosure {
            mapView.deselectAnnotation(view.annotation, animated: false)
            let addJob = UIAlertController(title: "Accept?", message: "Would you like to accept this request?", preferredStyle: UIAlertControllerStyle.alert)
            let acceptAction = UIAlertAction(title: "Accept", style: .default, handler: { (UIAlertAction) in
                let coord = Coordinate(latitude: Double((view.annotation?.coordinate.latitude)!) as NSNumber, longitude: Double((view.annotation?.coordinate.longitude)!) as NSNumber)
                //print("\(coord.latitude),\(coord.longitude)")
                let form = self.coordFormDict[coord]
                let user = FIRAuth.auth()!.currentUser!
                self.formService.addTakerToForm(takerID: user.uid, form: form!)
                if (form?.request)! {
                    self.userService.addNewOfferForm(user: user, form: form!)
                } else {
                    self.userService.addNewRequestForm(user: user, form: form!)
                }
                mapView.removeAnnotation(view.annotation!)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            addJob.addAction(acceptAction)
            addJob.addAction(cancelAction)
            present(addJob, animated: true, completion: nil)
        }
    }
    
    /**
     * Show current location when in use.
     *
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.mapView.showsUserLocation = (status == .authorizedWhenInUse)
    }
    
    /**
     * Get the current location and set the span of the region.
     *
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location updated")
        
        self.myLocation = (manager.location?.coordinate)!
        locationManager.stopUpdatingLocation()
        let coordinations = CLLocationCoordinate2D(latitude: self.myLocation.latitude ,longitude: self.myLocation.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegionMake(coordinations, span)
        self.mapView.setRegion(region, animated: true)
        //self.createAnnotations()
    }
    
    /**
     * Retrieves the form information
     *
     */
    func retrieveForms() {
        let formsRef = dataBaseRef.child("forms")
        formsRef.observe(.value, with: { (forms) in
            var resultArray = [Form]()
            for form in forms.children {
                let newForm = Form(snapshot: form as! FIRDataSnapshot)
                
                resultArray.append(newForm)
            }
            self.formArray = resultArray
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    /**
     * Gets form data and creates annotations for each.
     *
     */
    func createAnnotations() {
        for form in self.formArray {
            if form.takerUID == "" {
                let annotation = MKPointAnnotation()
                let coord = CLLocationCoordinate2D(latitude: CLLocationDegrees(form.latitude), longitude: CLLocationDegrees(form.longitude))
                annotation.coordinate = coord
                //print("\(coord.latitude) \(coord.longitude)")
                annotation.title = "\(form.firstName) \(form.zipcode) \(form.type)"
                annotation.subtitle = "\(form.message)"
                
                self.mapView.addAnnotation(annotation)
                
                let newCoord = Coordinate(latitude: form.latitude, longitude: form.longitude)
                coordFormDict[newCoord] = form
            }
        }
    }
    
}






