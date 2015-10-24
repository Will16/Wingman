//
//  PickerViewController.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/19/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit
import CoreLocation

let api = FourSquareAPI()
let lManager = CLLocationManager()
var venues = [ClubOrBarVenues]()


protocol didChooseVenueProtocol {
    
    func didReceiveVenueChoice(venue: ClubOrBarVenues)
}


class PickerViewController: UIViewController, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate, FoursquareAPIProtocol {

    var postData = [String:AnyObject]()
    var clubOrBar: ClubOrBarVenues?
    

    var delegate: PostViewController?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    

    

    @IBAction func backButton(sender: AnyObject) {
        
        self.presentingViewController?.tabBarController?.tabBar.hidden = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var pickerClubBar: UIPickerView!
    
    
    @IBAction func doneButton(sender: AnyObject) {
        
        if let _ = self.clubOrBar
        {
            showAlert()
            
            self.presentingViewController?.tabBarController?.tabBar.hidden = false
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.hidden = true
        backButton.alpha = 0

         self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.tabBarController?.tabBar.hidden = true
        
        pickerClubBar.dataSource = self
        pickerClubBar.delegate = self
        pickerClubBar.backgroundColor = UIColor.clearColor()
        
        if venues.count > 0 {
            
            
        } else {
            
            startUpdatingLocation()
            
        }
    
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        let scale1 = CGAffineTransformMakeScale(0.5, 0.5)
        let translate1 = CGAffineTransformMakeTranslation(0, 200)
        self.imageView.transform = CGAffineTransformConcat(scale1, translate1)
        
        spring(1) {
            
            self.imageView.hidden = false
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.imageView.transform = CGAffineTransformConcat(scale, translate)
        }

        
        backButton.alpha = 1
        springScaleFrom(backButton!, x: -100, y: 0, scaleX: 0.5, scaleY: 0.5)
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
    
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.presentingViewController?.tabBarController?.tabBar.hidden = true

    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        if pickerView == pickerClubBar {
            
            return 1
            
        }
        
        return 0
        
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerClubBar {
            
            return venues.count
        }
        
        return 0
    }
    
    
    //changes the color of the items in the pickerview rows to white
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let venue = venues[row]
       
        let attributedString = NSAttributedString(string: venue.name, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        
        return attributedString
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row < venues.count {
            
            let clubOrBar = venues[row]
            
             self.clubOrBar = clubOrBar
            //saves the club/bar in postData column in Parse
            postData ["clubOrBar"] = clubOrBar.name
         
        
           
            let location = clubOrBar.location
            
            let geoPoint = PFGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) as PFGeoPoint
            //saves location of club/bar in postData column in Parse
            postData["location"] = geoPoint
            
            print("\(row)", terminator: "")
            
            
            self.delegate?.didReceiveVenueChoice(clubOrBar)
            
            

            
        }
        
    }
    
    func showAlert() {
        
        let alertViewController = UIAlertController(title: "Saved", message: "Back to finding your Wingman", preferredStyle: UIAlertControllerStyle.Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
            
       
        }
        
        alertViewController.addAction(defaultAction)
        
        presentViewController(alertViewController, animated: true, completion: nil)
    }
    
    

//run the API call once to avoid maxing out rate limit
    var once: dispatch_once_t = 0
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let location = getLatestMeasurementFromLocations(locations)
        
        dispatch_once(&once, { () -> Void in
            
            print("my: \(location)", terminator: "")
            if self.isLocationMeasurementNotCached(location) && self.isHorizontalAccuracyValidMeasurement(location) {
                
                //                if self.isLocationMeasurementDesiredAccuracy(location) {
                
                self.stopUpdatingLocation()
                self.findVenues(location)
                
                //                } else {
                //
                //                    self.once = 0
                //
                //                }
                
            }
            
        })
        
    }
    
    func locationManager(manager:CLLocationManager, didFailWithError error:NSError) {
        if error.code != CLError.LocationUnknown.rawValue {
            stopUpdatingLocation()
        }
    }
    
    func getLatestMeasurementFromLocations(locations:[AnyObject]) -> CLLocation {
        return locations[locations.count - 1] as! CLLocation
    }
    
    func isLocationMeasurementNotCached(location:CLLocation) -> Bool {
        print("cache = \(location.timestamp.timeIntervalSinceNow)", terminator: "")
        return location.timestamp.timeIntervalSinceNow <= 5.0
    }
    
    func isHorizontalAccuracyValidMeasurement(location:CLLocation) -> Bool {
        print("accuracy = \(location.horizontalAccuracy)", terminator: "")
        return location.horizontalAccuracy >= 0
    }
    
    //    func isLocationMeasurementDesiredAccuracy(location:CLLocation) -> Bool {
    //        println("desired accuracy = \(lManager.desiredAccuracy)")
    //        return location.horizontalAccuracy <= lManager.desiredAccuracy
    //    }
    //
    
    func startUpdatingLocation() {
        lManager.delegate = self
        lManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            lManager.requestAlwaysAuthorization()
        }
        
        lManager.startUpdatingLocation()
        print("start updating location", terminator: "")
    }
    
    func stopUpdatingLocation() {
        lManager.stopUpdatingLocation()
        lManager.delegate = nil
    }
    
    func findVenues(location:CLLocation) {
        api.delegate = self;
        api.searchForClubOrBarAtLocation(location)
    }
    
    func didReceiveVenues(results: [ClubOrBarVenues]) {
        
        venues = results.sort({ (s1, s2) -> Bool in
            
            return (s1 as ClubOrBarVenues).distanceFromUser > (s2 as ClubOrBarVenues).distanceFromUser
            
        })
        
        print("boom", terminator: "")
        
        lastUpdated = NSDate()
        
        //        venues = sort(results, {$0.distanceFromUser < $1.distanceFromUser})
        
        pickerClubBar.reloadAllComponents()
    }

    
    @IBAction func logout(sender: AnyObject) {
        
     
        PFUser.logOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nc = storyboard.instantiateViewControllerWithIdentifier("loginNC") as! UINavigationController
        
        
        //presents LoginViewController without tabbar at bottom
        self.presentViewController(nc, animated: true, completion: nil)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


   

    // sending the club/bar choice over to PostVC
    
    
    


}
