//
//  BrowseDetailViewController.swift
//  Wingman
//
//  Created by William McDuff on 2015-03-06.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit
import MessageUI

class BrowseDetailViewController: UIViewController, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate {

    
    var event: [String: AnyObject]?
    var venueLocation: PFGeoPoint?

    
    var registerInfo: [String: AnyObject]?
    
    var postData: [String: AnyObject]?
    

    
    var phoneNumber: String?
    
    
    var myCustomBackButtonItem: UIBarButtonItem?
    
    var customButton: UIButton?

    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    
    @IBOutlet weak var genderLabel: UILabel!
    
    
    @IBOutlet weak var interestsLabel: UILabel!
    
    
    @IBOutlet weak var seekingLabel: UILabel!
    

    
    @IBOutlet weak var clubOrBarLabel: UILabel!
    
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var joinButton: UIButton!
    
    var imageView: UIImageView?
    
    @IBAction func joinButton(sender: AnyObject) {
         messageUser()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        print(self.phoneNumber)
        fillLabels()
        
        startUpdatingLocation()
        
        customButton = UIButton(type: UIButtonType.Custom) as? UIButton
        customButton!.setBackgroundImage(UIImage(named: "backbutton"), forState: UIControlState.Normal)
        
        
        customButton!.sizeToFit()
        
        customButton!.hidden = true
        customButton!.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        
        myCustomBackButtonItem = UIBarButtonItem(customView: customButton!)
        
        
        
        self.navigationItem.leftBarButtonItem = myCustomBackButtonItem

        imageView = UIImageView(frame: CGRect(x: -80, y: 0, width: 300, height: 40))
        
        
        imageView!.clipsToBounds = true
        
        imageView!.contentMode = .ScaleAspectFill
        
        imageView!.hidden = true
        let image = UIImage(named: "bar")
        imageView!.image = image
        navigationItem.titleView = imageView
        
        // Do any additional setup after loading the view.
        
        self.userImage.hidden = true
        self.joinButton.hidden = true
        
        
    }
    
    override func viewDidAppear(animated:Bool){
        
      //  self.navigationController?.navigationItem.backBarButtonItem =
        
        
        
        startUpdatingLocation()
        
        customButton!.hidden = false
        springScaleFrom(customButton!, x: -100, y: 0, scaleX: 0.5, scaleY: 0.5)

        
         imageView!.hidden = false
        springScaleFrom(imageView!, x: 200, y: 0, scaleX: 0.5, scaleY: 0.5)
        
         self.userImage.hidden = false
        springScaleFrom(userImage!, x: 0, y: -400, scaleX: 0.5, scaleY: 0.5)
        
        self.joinButton.hidden = false
        springScaleFrom(joinButton!, x: 0, y: 200, scaleX: 0.5, scaleY: 0.5)
        
        
    }
    
    
    func popToRoot(sender:UIBarButtonItem) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    func fillLabels() {
        
       
            
            if let event = event  {
                
                
                
                
                
                
                if let clubOrBar = event["venue"] as? String {
                    
                    self.clubOrBarLabel.text = clubOrBar
                }
                
                if let startTime = event["start_time_string"] as? String {
                    
                    self.startTimeLabel.text = "From: \(startTime)"
                }
                
                if let endTime = event["end_time_string"] as? String {
                    
                    self.endTimeLabel.text = "To: \(endTime)"
                    
                    
                }
                
                if let wingmanGender = event["wingman_gender"] as? String {
                    
                    self.seekingLabel.text = "Seeking \(wingmanGender) Wingman"
                    
                }
                
                //retrieving location from Parse
                if let latitudeFloat = event["latitude"] as? Float {
                    
                    if let longitudeFloat = event["longitude"] as? Float {
                        
                        
                        
                        let latitude = Double(latitudeFloat)
                        let longitude = Double(longitudeFloat)
                        
                        print("LATITUDE IS : \(latitude)")
                        print("LONGITUDE IS : \(longitude)")
                        let venueLocation = PFGeoPoint(latitude: latitude, longitude: longitude)
                        self.venueLocation = venueLocation
                    }
                    
                }
                
                if let interests = event["creator_interests"] as? String {
                    
                    self.interestsLabel.text = interests
                }
                

                
                if let userInfo = event["user"] as? [String: AnyObject] {
                    
                    if let username = userInfo["username"] as? String {
                        
                        self.usernameLabel.text = username
                    }
                    
                    if let interests = userInfo["interests"] as? String {
                        
                        self.interestsLabel.text = interests
                    }
                    
                    if let gender = userInfo["gender"] as? String {
                        
                        self.genderLabel.text = gender
                    }

//                    if let urlString = userInfo["image_string"] as? String {
//                        
//                        println(urlString)
//                        let url = NSURL(string: urlString)
//                        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
//                        
//                        
//                    }
                    
                    if let urlString = userInfo["image_string"] as? String {
                        
                        let urlParts = urlString.componentsSeparatedByString("/")
                        
                        if let fileName = urlParts.last {
                            
                            var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                            let filePath = paths[0] + fileName
                            
                            getImageWithFilePath(filePath, fileName: fileName, completion: { () -> () in
                                
                                let image = UIImage(contentsOfFile: filePath)
                                
                                self.userImage.image = image
                                
                            })
                            
                        }
                        
                        
                    }
                }
                
                

                }
                
       
                
        
        
    }
    
    //sending phone number to TextMessageViewController before going to text messaging client
  
    
func getImageWithFilePath(filePath: String, fileName: String, completion: (() -> ())?) {
    
    
    if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
        
        if let c = completion { c() }
        
    }
    
    do {
        // if timestamp of update then delete and redownload ... TODO
        try NSFileManager.defaultManager().removeItemAtPath(filePath)
    } catch _ {
    }
    
    let outputStream = NSOutputStream(toFileAtPath: filePath, append: false)
    
    // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 1)), dispatch_get_main_queue()) { () -> Void in
    
    S3.model().s3Manager.getObjectWithPath(fileName, outputStream: outputStream, progress: { (bytesRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
        
        //                println("\(Int(CGFloat(totalBytesRead) / CGFloat(totalBytesExpectedToRead) * 100.0))% Downloaded")
        
        }, success: { (responseObject) -> Void in
            
            print("image saved")
            
            if let c = completion { c() }
            
        }) { (error) -> Void in
            
    }
    
    
}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        print("Springtime is here!!!")
        let location = getLatestMeasurementFromLocations(locations)
        
        
        print("my location: \(location)")
        if isLocationMeasurementNotCached(location) && isHorizontalAccuracyValidMeasurement(location) && isLocationMeasurementDesiredAccuracy(location) {
            
            stopUpdatingLocation()
           
            if let latitude =  self.venueLocation?.latitude  as Double? {
                
                if let longitude = self.venueLocation?.longitude as Double? {
                    
                    if let venueLocation = CLLocation(latitude: latitude, longitude: longitude) as CLLocation? {
                        
                        //convert meters into miles
                        let dist1 = venueLocation.distanceFromLocation(location) * 0.00062137
                        
                        //rounding to nearest hundredth
                        let dist2 = Double(round(100 * dist1) / 100)
                        
                        
                        self.distanceLabel.text = "Which is \(dist2) mi from you"
                        
                        print("THE DISTANCE: \(dist2)")
                    }
                }
                
            }
            
        }
    }
    
    //if error stop updating location
    func locationManager(manager:CLLocationManager, didFailWithError error:NSError) {
        if error.code != CLError.LocationUnknown.rawValue {
            stopUpdatingLocation()
        }
    }
    
    func getLatestMeasurementFromLocations(locations:[AnyObject]) -> CLLocation {
        return locations[locations.count - 1] as! CLLocation
    }
    
    func isLocationMeasurementNotCached(location:CLLocation) -> Bool {
        return location.timestamp.timeIntervalSinceNow <= 5.0
    }
    
    func isHorizontalAccuracyValidMeasurement(location:CLLocation) -> Bool {
        return location.horizontalAccuracy >= 0
    }
    
    func isLocationMeasurementDesiredAccuracy(location:CLLocation) -> Bool {
        
        return location.horizontalAccuracy <= lManager.desiredAccuracy
    }
    
    func startUpdatingLocation() {
        lManager.delegate = self
        lManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            lManager.requestAlwaysAuthorization()
        }
        
        lManager.startUpdatingLocation()
        print("start updating location")
    }
    
    func stopUpdatingLocation() {
        lManager.stopUpdatingLocation()
        lManager.delegate = nil
    }
    
    func messageUser() {
        if MFMessageComposeViewController.canSendText() {
            let messageController:MFMessageComposeViewController = MFMessageComposeViewController()
            
            
            if let phoneNumber = self.phoneNumber as String? {
                
                messageController.recipients = ["\(phoneNumber)"]
                
                messageController.messageComposeDelegate = self
                
                self.presentViewController(messageController, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        
        User.currentUser().token = nil
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nc = storyboard.instantiateViewControllerWithIdentifier("loginNC") as! UINavigationController
        
        
        //presents LoginViewController without tabbar at bottom
        self.presentViewController(nc, animated: true, completion: nil)

        
    }
    


}
