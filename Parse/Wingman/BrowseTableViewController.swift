//
//  BrowseTableViewController.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/3/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit

class BrowseTableViewController: UITableViewController, userLocationProtocol, CLLocationManagerDelegate {
    
    
    var phoneNumber: String?
    
    var wingmen: [[String:AnyObject]] = []
    
    
    var arrayOfRegisterInfo = [[String: AnyObject]]()
    
    var arrayOfPostData = [[String: AnyObject]]()
    
    var userLocation: CLLocation?
    var tabBarImageView: UIImageView?
    
    var gender: String?
    var seekingGender: String?
    
//    var tempGeoPoint = PFGeoPoint(latitude: 33.78604932800356, longitude: -84.37840104103088)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        GlobalVariableSharedInstance.delegate = self
        
        GlobalVariableSharedInstance.startUpdatingLocation()
        
         self.loadCurrentUserAndThenLoadUsers()
        
        tabBarImageView = UIImageView(frame: CGRect(x: -80, y: 0, width: 300, height: 40))
        
        
        tabBarImageView!.clipsToBounds = true
        
        tabBarImageView!.contentMode = .ScaleAspectFill
        
        tabBarImageView!.hidden = true
        
        let image = UIImage(named: "bar")
        tabBarImageView!.image = image
        navigationItem.titleView = tabBarImageView
        
        
        //  tableView.separatorColor = UIColor.blueColor()
        
        tableView.layoutMargins = UIEdgeInsetsZero
        
        tableView.separatorInset = UIEdgeInsetsZero
        
        let gradientView = GradientView(frame: CGRectMake(view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height))
        
        // Set the gradient colors
        
        
        
        
        
        gradientView.colors = [UIColor.blackColor(), UIColor.darkGrayColor()]
        
        // Optionally set some locations
        //   gradientView.locations = [0.0, 1.0]
        
        // Optionally change the direction. The default is vertical.
        gradientView.direction = .Vertical
        
        
        
        //
        //        gradientView.topBorderColor = UIColor.blueColor()
        //        gradientView.bottomBorderColor = UIColor.blueColor()
        //
        //
        
        tableView.backgroundView = gradientView
        
        
        
        // self.tableView.hidden = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        
        tabBarImageView!.hidden = true
        //  self.tableView.hidden = true
        
        self.tableView.backgroundColor = UIColor.blackColor()
        
        //sets navigation bar to a clear black color
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        //sets navigation bar's "Back" button item to white
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let backButton = UIBarButtonItem()
        let backButtonImage = UIImage(named: "backbutton")
        backButton.setBackButtonBackgroundImage(backButtonImage, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        
        self.navigationController?.navigationItem.backBarButtonItem = backButton
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        //  self.tableView.hidden = false
        self.tableView.backgroundColor = UIColor.blackColor()
        
        
        //sets navigation bar to a clear black color
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        //sets navigation bar's "Back" button item to white
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let backButton = UIBarButtonItem()
        let backButtonImage = UIImage(named: "backbutton")
        backButton.setBackButtonBackgroundImage(backButtonImage, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        
        self.navigationController?.navigationItem.backBarButtonItem = backButton
        
        tabBarImageView!.hidden = false
        springScaleFrom(tabBarImageView!, x: 0, y: -100, scaleX: 0.5, scaleY: 0.5)
        
        // addBlurEffect()
        
        
        
    }
    
    func addBlurEffect() {
        // Add blur view
        let bounds = self.navigationController?.navigationBar.bounds as CGRect!
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.navigationController?.navigationBar.addSubview(visualEffectView)    // Here you can add visual effects to any UIView control.
        // Replace custom view with navigation bar in above code to add effects to custom view.
    }
    
    func loadCurrentUserAndThenLoadUsers() {
        let query = PFUser.query()
        query.whereKey("objectId", equalTo: PFUser.currentUser().objectId)
        
        print("OBJECTID + \(PFUser.currentUser().objectId)")
        query.findObjectsInBackgroundWithBlock() {
            (objects:[AnyObject]!, error:NSError!)->Void in
            if ((error) == nil) {
                
                if let user = objects.last as! PFUser? {
                    
                    
                    
                    // if we created a postData, the user has a wingmanGender in parse that user is seeking
                    if let seekingGender = user["wingmanGender"] as! String? {
                        
                        if let gender = user["gender"] as! String? {
                            
                            self.gender = gender
                            self.seekingGender = seekingGender
                            
                            self.loadUsers(self.seekingGender, ourGender: self.gender)
                        }
                        
                    }
                        
                        
                        
                        
                        
                    else {
                        
                        self.loadUsers(self.seekingGender, ourGender: self.gender)
                        
                    }
                }
            }
            
            
        }
        
    }
    
    func loadUsers(seekingGender: String?, ourGender: String?) {
        
        
        
        
        //        var query = PFQuery(className:"_User")
        let query = PFUser.query()
        
        
        query.whereKeyExists("postData")
        
        query.whereKey("objectId", notEqualTo: PFUser.currentUser().objectId)
        
        
        
//        query.whereKey("location", nearGeoPoint: tempGeoPoint, withinMiles: 1000)
        
        if (self.userLocation != nil) {
            query.whereKey("location", nearGeoPoint: PFGeoPoint(location: userLocation), withinMiles: 1000)
        }
        
        
        // if we have a seekingGender, then load only users whose gender is our seekingGender, else return all users that are not current user (never go into that loop)
        if let seekingGender = seekingGender as String? {
            
            if let ourGender = ourGender as String? {
                
                if seekingGender == "both" {
                    query.whereKey("wingmanGender", equalTo: ourGender)
                }
                
                else {
                    query.whereKey("gender", equalTo: seekingGender)
                    
                    query.whereKey("wingmanGender", equalTo: ourGender)
                }
               
                
            }
            
        }
        
        
        query.findObjectsInBackgroundWithBlock() {
            (objects:[AnyObject]!, error:NSError!)->Void in
            if ((error) == nil) {
                
                
                self.arrayOfPostData.removeAll()
                self.arrayOfRegisterInfo.removeAll()
                for user in objects {
                    
                    if let registerInfo = user["registerInfo"] as? [String: AnyObject] {
                        
                        self.arrayOfRegisterInfo.append(registerInfo)
                        
                    }
                    
                    if let postData = user["postData"] as? [String: AnyObject] {
                        self.arrayOfPostData.append(postData)
                        
                        
                    }
                }
                
                
            }
            self.tableView.reloadData()
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.arrayOfRegisterInfo.count
    }
    
    
    
    
    override func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BrowseTableViewCell
        
        cell.selectionStyle = .None
        
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()
        
        
        var registerInfo = self.arrayOfRegisterInfo[indexPath.row]
        
        
        if let imageFile = registerInfo["imageFile"] as? PFFile {
            imageFile.getDataInBackgroundWithBlock({
                (imageData: NSData!, error: NSError!) in
                if (error == nil) {
                    
                    
                    let image : UIImage = UIImage(data:imageData)!
                    //image object implementation
                    
                    cell.userImage.image = image
                }
                    
                    
                else {
                    print(error.description)
                }
            })
            
        }
        
        
        if let username = registerInfo["username"] as? String {
            cell.usernameLabel.text = username
        }
        
  
        
        var postData = self.arrayOfPostData[indexPath.row]
        
        if let clubOrBar = postData["clubOrBar"] as? String {
            
            cell.clubOrBarLabel.text = clubOrBar
            
            
        }
        
        //        if let seeking = postData["wingmanGender"] as? String {
        //
        //            cell.seekingLabel.text = "Seeking: \(seeking)"
        //
        //        }
        
        
        if let startTimeInt = postData["startTime"] as? Int {
            
            
            if let endTimeInt = postData["endTime"] as? Int {
                
                
                cell.timeLabel.text = "From: \(startTimeInt) To: \(endTimeInt)"
            }
            
            
        }
        
        
        if let userLocation = self.userLocation {
            
            if let venueLocation =  postData["location"] as? PFGeoPoint  {
                
                
                if let venueLocation = CLLocation(latitude: venueLocation.latitude, longitude: venueLocation.longitude) as CLLocation? {
//                    
//                    let tempCLLocation = CLLocation(latitude: self.tempGeoPoint!.latitude, longitude: self.tempGeoPoint!.longitude) as CLLocation?
                    //convert meters into miles
                   
                    
//                    let dist1 = venueLocation.distanceFromLocation(tempCLLocation!) * 0.00062137

                    
                     let dist1 = venueLocation.distanceFromLocation(userLocation) * 0.00062137
                    
                    //rounding to nearest hundredth
                    let dist2 = Double(round(100 * dist1) / 100)
                    
                    
                    cell.distanceLabel.text = "\(dist2) mi from you"
                    
                    print("THE DISTANCE: \(dist2)", terminator: "")
                }
            }
            
            
        }
        
        
        
        
        return cell
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //       let cell: BrowseTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as BrowseTableViewCell
        
        //didn't connect segue in storyboard so doing it programmatically here
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("browseDetailVC") as! BrowseDetailViewController
        
        //self for global variables/properties
        let registerInfo = self.arrayOfRegisterInfo[indexPath.row]
        var postData = self.arrayOfPostData[indexPath.row]
        
        //sending data to BrowseDetailViewController
        vc.registerInfo = registerInfo
        vc.postData = postData
        
        if let phoneNumber = postData["phonenumber"] as! String? {
            
            
            
            //            self.phoneNumber = phoneNumber
            vc.phoneNumber = phoneNumber
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
        
        
        
    }
    
    func didReceiveUserLocation(location: CLLocation) {
        
        userLocation = location
        
        
        self.loadCurrentUserAndThenLoadUsers()
    }
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //
    //        if segue.identifier == "phoneSegue" {
    //
    //
    //
    //            let vc = segue.destinationViewController as TextMessageViewController
    //            
    //            println(phoneNumber)
    //            vc.phoneNumber = self.phoneNumber
    //            
    //        }
    //    
    //    }
    
    
    
}
