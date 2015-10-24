//
//  BrowseTableViewController.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/3/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit

class BrowseTableViewController: UITableViewController,  didGetEventsProtocol {
    
    
    var phoneNumber: String?
    
    var wingmen: [[String:AnyObject]] = []
    
    
    var arrayOfRegisterInfo = [[String: AnyObject]]()
    
     var arrayOfPostData = [[String: AnyObject]]()
    
       var tabBarImageView: UIImageView?
    
     var arrayOfEvents = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   
        
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
    
        User.currentUser().getEventsDelegate  = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        User.currentUser().getEvents()
        
        
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
        
        var backButton = UIBarButtonItem()
        var backButtonImage = UIImage(named: "backbutton")
        backButton.setBackButtonBackgroundImage(backButtonImage, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
     
        self.navigationController?.navigationItem.backBarButtonItem = backButton
        
        tabBarImageView!.hidden = false
        springScaleFrom(tabBarImageView!, x: 0, y: -100, scaleX: 0.5, scaleY: 0.5)
        
            // addBlurEffect()
        
        self.tableView.reloadData()
        
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
        return self.arrayOfEvents.count
    }

    
 
    
    override func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.separatorInset = UIEdgeInsetsZero
         cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
       
    }
    
    
    // func that takes the filePath (the filePath for the directory where our imageFile is stored) and the fileName (the specific string we created which includes our imageName and a randomNumber)
   
    func getImageWithFilePath(filePath: String, fileName: String, completion: (() -> ())?) {
        
        
    
        // NSFileManager is a predefined iOS class
        // we check if there is an imageFile in the directory (using the filePath of our directory)
        // if there is an imageFile returns true else return false
        
        
        if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
            
            
            // if there is an imageFile in the directory then completion = true
            //  IF THERE IS ALREADY AN IMAGEFILE (WE ALREADY DOWNLOADED IT) IN OUR COMPUTER DIRECTORY WE DON'T NEED TO DOWNLOAD THE IMAGE FROM S3, SO COMPLETION (CODE BELOW DOESN'T GET EXECUTED)
            if let c = completion { c() }
            
        }
        
        
        do {
            // IF THERE IS NO IMAGE IN OUR DIRECTORY (WE DIDN'T ALREADY DOWNLOADED IT, SO METHOD DOESN'T END AT COMPLETION ABOVE), THEN DOWNLOAD IMAGEFILE FROM S3 LINK (THAT WE STORED EARLIER IN REGISTERVIEWCONTROLLER)
        
            // AT EVERY STEP OF THE DOWNLOAD OF THE IMAGEFILE, OUTPUT STREAM CHANGES AND THEN WE UPDATE THE IMAGEFILE AT DIRECTORY (BY DELETING THE OLD ONE AND ADDING THE UPDATED ONE)
  
            
            // remove old imageFile
            try NSFileManager.defaultManager().removeItemAtPath(filePath)
        } catch _ {
        }
        
        // update the file at the filePath directory
        // OutputStream is the data we receive from the request (the downloading of the image from the imageFile)
        let outputStream = NSOutputStream(toFileAtPath: filePath, append: false)
        
       // getObjectWithPath download the image from the imageFile (the OutputStream) of the directory. It takes the fileName of the directory and the outputStream  (OutputStream is the imageFile we downloaded from S3)
        S3.model().s3Manager.getObjectWithPath(fileName, outputStream: outputStream, progress: { (bytesRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
            
            //                println("\(Int(CGFloat(totalBytesRead) / CGFloat(totalBytesExpectedToRead) * 100.0))% Downloaded")
            
            },
            
            // if the image is succesfully downloaded from the imageFile stored in S3 then completion
            success: { (responseObject) -> Void in
                
                print("image saved")
                
                if let c = completion { c() }
                
            }) { (error) -> Void in
                
                // if error do stuff
        }
        
        
    }
  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BrowseTableViewCell

        cell.selectionStyle = .None
        
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()


        
        var event = self.arrayOfEvents[indexPath.row]
        
        
        if let venue = event["venue"] as? String {
            
            cell.clubOrBarLabel.text = venue
            
            
        }
        
        //        if let seeking = postData["wingmanGender"] as? String {
        //
        //            cell.seekingLabel.text = "Seeking: \(seeking)"
        //
        //        }
        
        
        if let startTimeInt = event["start_time_string"] as? String {
            
            
            if let endTimeInt = event["end_time_string"] as? String {
                
                
                cell.timeLabel.text = "From: \(startTimeInt) To: \(endTimeInt)"
            }
            
            
        }

    

    
    
        if let userInfo = event["user"] as! [String: AnyObject]? {
            
            if let username = userInfo["username"] as? String {
                cell.usernameLabel.text = username
            }
            if let gender = userInfo["gender"] as? String {
                
                cell.genderLabel.text = "Gender: \(gender)"
                
            }
            
            
            
            // take the amazonS3 URL link that we sent to the Rails API, and that the Rails API sent us back
            // THE URL LINK CONTAINS THE FILENAME OF OUR IMAGE AND WE USE THAT FILENAME TO FIND THE DIRECTORY WHERE OUR IMAGEFILE IS STORED
            if let urlString = userInfo["image_string"] as? String {
                
                // create all the components separated by / in the URL and store them in an array of string that call urlParts
                let urlParts = urlString.componentsSeparatedByString("/")
                
                
                // take the last part of the URL (our fileName (the specific string that we created for our image (which include our imageName and a random number))
                if let fileName = urlParts.last {
                    
                    // grab the directory where we stored our imageName (the directory has our fileName (the image name with the random number) at the end of it)
                    var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                    let filePath = paths[0] + fileName
                    
                    
                    // SEE THE GETIMAGEWITHFILEPATH METHOD IN THIS CLASS
                    // this function takes our filePath directory and our fileName and gets the image from the imageFile in the directory
                    getImageWithFilePath(filePath, fileName: fileName, completion: { () -> () in
                        
                        
                        // take the contentsOfTheImageFile in our directory and create an image with that file
                        let image = UIImage(contentsOfFile: filePath)
                        
                        // display the image in the userImageView
                        cell.userImage.image = image
                        
                    })
                    
                }
                
               
            }
        }

        
            return cell

            
    
      
        
        
    }
    
    func didGetAllEvents(events: [[String: AnyObject]]) {
        

        for event in events {
            self.arrayOfEvents.append(event)
        }
        
        self.tableView.reloadData()
        
    }
    
    func didNotGetAllEvents(error: String?) {
        let alert:UIAlertView = UIAlertView(title: "Get Events Unsuccessful", message: error, delegate: nil, cancelButtonTitle: "Ok")
        
        alert.show()
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //       let cell: BrowseTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as BrowseTableViewCell
        
        //didn't connect segue in storyboard so doing it programmatically here
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("browseDetailVC") as! BrowseDetailViewController
        
        //self for global variables/properties
        
        //sending data to BrowseDetailViewController
        
        /*
        vc.registerInfo = registerInfo
        vc.postData = postData
        */
        
        var event = self.arrayOfEvents[indexPath.row]
        
        vc.event = event
        if let phoneNumber = event["creator_phone_number"] as? String {
            
            
            
            //            self.phoneNumber = phoneNumber
            vc.phoneNumber = phoneNumber
            
            
        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        

        
        
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
