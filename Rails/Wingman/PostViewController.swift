//
//  PostViewController.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/4/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit
import CoreLocation

var lastUpdated: NSDate?

class PostViewController: UIViewController, didChooseVenueProtocol, didPostEventProtocol {
        
    var postData = [String:AnyObject]()
    var clubOrBar: ClubOrBarVenues?
    
    @IBOutlet weak var venueChoiceLabel: UILabel!
    
    @IBOutlet weak var genderSwitch: UISwitch!
    
    
    @IBOutlet weak var startTime: UITextField!
    
    
    @IBOutlet weak var endTime: UITextField!
    
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var backgroundMaskView: UIView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var chooseBarButton: UIButton!
    
    @IBOutlet weak var postButton: UIButton!
    
    @IBOutlet weak var postImageView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var tabBarImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         User.currentUser().postEventDelegate = self
        self.tabBarController?.tabBar.hidden = false
        // Do any additional setup after loading the view.
        
//        pickerClubBar.dataSource = self
//        pickerClubBar.delegate = self
//        pickerClubBar.backgroundColor = UIColor.clearColor()
        
     
    //   insertBlurView(backgroundMaskView, UIBlurEffectStyle.Dark)
        
        
        postData["wingmanGender"] = "female"
        //postData["venues"] = ""
        genderSwitch.addTarget(self, action: "switchIsChanged:", forControlEvents: .ValueChanged)
        
        
        // add if lastUpdated timeinterval is less than 5 minutes
       /* if venues.count > 0 {
            
            
        } else {
            
            startUpdatingLocation()
            
        }*/
        
        tabBarImageView = UIImageView(frame: CGRect(x: -80, y: 0, width: 300, height: 40))
        
        
        tabBarImageView!.clipsToBounds = true
        
        tabBarImageView!.contentMode = .ScaleAspectFill
        
        tabBarImageView!.hidden = true
        let image = UIImage(named: "bar")
        tabBarImageView!.image = image
        navigationItem.titleView = tabBarImageView

    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        
        self.postButton.hidden = true
        self.chooseBarButton.hidden = true
        
        self.postImageView.hidden = true
        
        self.imageView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        //sets navigation bar to a clear black color
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        //sets navigation bar's "Back" button item to white
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.tabBarController?.tabBar.hidden = false
        //"You chose: " label stuff here
        //venueChoiceLabel.text = "You chose: \()"
        
        var scale1 = CGAffineTransformMakeScale(0.5, 0.5)
        var translate1 = CGAffineTransformMakeTranslation(0, -100)
        self.chooseBarButton.transform = CGAffineTransformConcat(scale1, translate1)
        
        tabBarImageView!.hidden = false
        springScaleFrom(tabBarImageView!, x: 0, y: -100, scaleX: 0.5, scaleY: 0.5)
        
      
        
        spring(1) {
            
            self.chooseBarButton.hidden = false
            var scale = CGAffineTransformMakeScale(1, 1)
            var translate = CGAffineTransformMakeTranslation(0, 0)
            self.chooseBarButton.transform = CGAffineTransformConcat(scale, translate)
        }
        
        // animate the textViews
        
        
        var scale2 = CGAffineTransformMakeScale(0.5, 0.5)
        var translate2 = CGAffineTransformMakeTranslation(0, 100)
        self.postButton.transform = CGAffineTransformConcat(scale2, translate2)
        
        self.postImageView.transform = CGAffineTransformConcat(scale2, translate2)
        self.imageView.transform = CGAffineTransformConcat(scale2, translate2)
        
        spring(1) {
            self.postButton.hidden = false
            self.postImageView.hidden = false
            self.imageView.hidden = false
            var scale = CGAffineTransformMakeScale(1, 1)
            var translate = CGAffineTransformMakeTranslation(0, 0)
            self.postButton.transform = CGAffineTransformConcat(scale, translate)
            self.postImageView.transform = CGAffineTransformConcat(scale, translate)
            self.imageView.transform = CGAffineTransformConcat(scale, translate)
            
            
        }
        
 

        
    }
    
    @IBAction func submitPostButton(sender: AnyObject) {
        
      
        
        if postData["clubOrBar"] != nil && startTime.text != "" && endTime.text != "" && phoneNumber.text != ""
            
        {
            
            
            
            
            postData["startTime"] = Int(startTime.text!)
            
            postData["endTime"] = Int(endTime.text!)
            
            postData["phonenumber"] = phoneNumber.text
            
            var venue = postData["clubOrBar"] as! ClubOrBarVenues
            var venueName = venue.name
            
            var latitudeDegrees = venue.location.coordinate.latitude
            
            var longitudeDegrees = venue.location.coordinate.longitude
            
            var latitude = Float(latitudeDegrees)
            var longitude = Float(longitudeDegrees)
            var wingmanGender = postData["wingmanGender"] as! String
            User.currentUser().postEvent(venueName, latitude: latitude, longitude: longitude, startTime: startTime.text!,  endTime: endTime.text!, wingmanGender: wingmanGender)
            
            
            
            // for protocol
            
            
            
            
            
            
        }
            
        else {
            
            var alertViewController = UIAlertController(title: "Submission Error", message: "Please complete all fields", preferredStyle: UIAlertControllerStyle.Alert)
            
            var defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertViewController.addAction(defaultAction)
            
            presentViewController(alertViewController, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "postToPicker" {
            
            let vc = segue.destinationViewController as! PickerViewController
            
            vc.delegate = self
            
        }
    }
    func showAlert() {
        
        let alertViewController = UIAlertController(title: "Your post was created!", message: "Now back to browsing", preferredStyle: UIAlertControllerStyle.Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
            
            self.performSegueWithIdentifier("BrowserSegue", sender: self)
        }
        
        alertViewController.addAction(defaultAction)
        
        presentViewController(alertViewController, animated: true, completion: nil)
    }


     //this takes us to Browser after post button is pushed and info has been successfully sent to parse
    
    
    
    func goToBrowseTableVC() {
        
        let tbc = storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
        
        print(tbc)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController = tbc
//
//        self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("view2") as UIViewController, animated: true)
        
        
    }
    

    
    //array of clubs/bars in Atl needs to be pulled from Foursquare API to populate pickerview
    
   // var clubsAndBarsList = venues
    
    
    //dismiss the keyboard when tapping anywhere on view
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    //function letting us know which gender user chose and sending dictionary to Parse
    func switchIsChanged(sender: UISwitch){
        
        print("Sender is = \(sender)")
        
        if genderSwitch.on{
            
            postData["wingmanGender"] = "male"
            
            print("The switch is turned to male")
            
            
        } else {
            
            postData["wingmanGender"] = "female"
            
            print("The switch is turned to female")
        }
        
    }


    
    /*
    
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

    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var venue = venues[row]
        var venueName = venue.name

        let attributedString = NSAttributedString(string: venue.name, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])

        return attributedString
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row < venues.count {
            
            var clubOrBar = venues[row]
            
            //this creates the club/bar dictionary choice
            postData ["clubOrBar"] = clubOrBar.name
            var location = clubOrBar.location
            
            let geoPoint = PFGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) as PFGeoPoint
            
            postData["location"] = geoPoint
            
            println("\(row)")
            
        }
        
    }
    */
    
    
    func didReceiveVenueChoice(venue: ClubOrBarVenues) {
        
        postData["clubOrBar"] = venue
        
        let venueName = venue.name
        
        
        venueChoiceLabel.text = "You chose:\n\(venueName)"
        
        chooseBarButton.setTitle(venueName, forState: UIControlState.Normal)
        
        
    }
    
    
    func didReceiveEvent() {
        
        self.showAlert()
        
        
        self.goToBrowseTableVC()
        
    }
    
    func didNotReceiveEvent(error: String?) {
        let alert:UIAlertView = UIAlertView(title: "Post Event Unsuccessful", message: error, delegate: nil, cancelButtonTitle: "Ok")
        
        alert.show()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        
        let user = PFUser.currentUser() as PFUser
        
        PFUser.logOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nc = storyboard.instantiateViewControllerWithIdentifier("loginNC") as! UINavigationController
        
        
        //presents LoginViewController without tabbar at bottom
        self.presentViewController(nc, animated: true, completion: nil)
        
    }
    
    
    
    /*
    
    var once: dispatch_once_t = 0
    
    func locationManager(manager:CLLocationManager!, didUpdateLocations locations:[AnyObject]!) {
        let location = getLatestMeasurementFromLocations(locations)
        
        dispatch_once(&once, { () -> Void in
            
            println("my: \(location)")
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
    
    func locationManager(manager:CLLocationManager!, didFailWithError error:NSError!) {
        if error.code != CLError.LocationUnknown.rawValue {
            stopUpdatingLocation()
        }
    }
    
    func getLatestMeasurementFromLocations(locations:[AnyObject]) -> CLLocation {
        return locations[locations.count - 1] as CLLocation
    }
    
    func isLocationMeasurementNotCached(location:CLLocation) -> Bool {
        println("cache = \(location.timestamp.timeIntervalSinceNow)")
        return location.timestamp.timeIntervalSinceNow <= 5.0
    }
    
    func isHorizontalAccuracyValidMeasurement(location:CLLocation) -> Bool {
        println("accuracy = \(location.horizontalAccuracy)")
        return location.horizontalAccuracy >= 0
    }
    
    */
    
//    func isLocationMeasurementDesiredAccuracy(location:CLLocation) -> Bool {
//        println("desired accuracy = \(lManager.desiredAccuracy)")
//        return location.horizontalAccuracy <= lManager.desiredAccuracy
//    }
//    
    
   /* func startUpdatingLocation() {
        lManager.delegate = self
        lManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            lManager.requestAlwaysAuthorization()
        }
    
        lManager.startUpdatingLocation()
        println("start updating location")
    }
    
    func stopUpdatingLocation() {
        lManager.stopUpdatingLocation()
        lManager.delegate = nil
    }
    
    func findVenues(location:CLLocation) {
        api.delegate = self
        api.searchForClubOrBarAtLocation(location)
    }
    
    func didReceiveVenues(results: [ClubOrBarVenues]) {
               
        venues = sorted(results, { (s1, s2) -> Bool in
            
            return (s1 as ClubOrBarVenues).distanceFromUser > (s2 as ClubOrBarVenues).distanceFromUser
            
        })
        
        println("boom")
        
        lastUpdated = NSDate()
        
//        venues = sort(results, {$0.distanceFromUser < $1.distanceFromUser})
        
        pickerClubBar.reloadAllComponents()
    }
*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
