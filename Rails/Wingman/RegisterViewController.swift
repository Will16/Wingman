//
//  RegisterViewController.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/2/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit
@IBDesignable



class RegisterViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SignedInProtocol

{
    
   
    
    let segments = ["male", "female"]
    
    
    var registerInfo = [String:AnyObject]()
    
    var myCustomBackButtonItem: UIBarButtonItem?
    
    var customButton: UIButton?
    
    
    var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        pickProfilePicButton.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlState.Highlighted)
//        
    
    
         User.currentUser().registerDelegate  = self
        
        self.registerInfo["gender"] = "male"
        
        self.interestField.layer.cornerRadius = 5
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
   
        customButton = UIButton(type: UIButtonType.Custom)
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


        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.imageView!.hidden = true


        self.createUsernameField.hidden = true
        self.createPasswordField.hidden = true
        self.enterEmailField.hidden = true
        
        self.pickedImage.hidden = true
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
     
        customButton!.hidden = false
         self.imageView!.hidden = false
         springScaleFrom(customButton!, x: -100, y: 0, scaleX: 0.5, scaleY: 0.5)
 
  


        springScaleFrom(imageView!, x: 200, y: 0, scaleX: 0.5, scaleY: 0.5)
       
        self.logoImageView.layer.cornerRadius = 50
        self.logoImageView.clipsToBounds = true
        
        // animate the logoImageView
        let scale1 = CGAffineTransformMakeScale(0.5, 0.5)
        let translate1 = CGAffineTransformMakeTranslation(0, -100)
        self.createUsernameField.transform = CGAffineTransformConcat(scale1, translate1)
        
        spring(1) {
     
            self.createUsernameField.hidden = false
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.createUsernameField.transform = CGAffineTransformConcat(scale, translate)
        }
        
        // animate the textViews
        
        
        let scale2 = CGAffineTransformMakeScale(0.5, 0.5)
        let translate2 = CGAffineTransformMakeTranslation(0, -100)
        self.enterEmailField.transform = CGAffineTransformConcat(scale2, translate2)
        
        spring(1) {
            self.enterEmailField.hidden = false
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.enterEmailField.transform = CGAffineTransformConcat(scale, translate)
       
            
        }
        
        var scale3 = CGAffineTransformMakeScale(0.5, 0.5)
        var translate3 = CGAffineTransformMakeTranslation(0, -100)
        self.createPasswordField.transform = CGAffineTransformConcat(scale3, translate3)
        
        spring(1) {
            self.createPasswordField.hidden = false
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.createPasswordField.transform = CGAffineTransformConcat(scale, translate)
       
            
        }

        
        let scale4 = CGAffineTransformMakeScale(0.5, 0.5)
        var translate4 = CGAffineTransformMakeTranslation(0, 200)
        self.pickedImage.transform = CGAffineTransformConcat(scale4, translate4)
        
        spring(1) {
            self.pickedImage.hidden = false
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.pickedImage.transform = CGAffineTransformConcat(scale, translate)
            
            
        }
        
        if pickProfilePicButton.highlighted == true {
            pickProfilePicButton.backgroundColor = UIColor.blueColor()
            
        }
            
        if pickProfilePicButton.highlighted == false{
            pickProfilePicButton.backgroundColor = UIColor.clearColor()
        }

        
        if let _ = User.currentUser().token  {
            
            
            let tbc = storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
            
            
            tbc?.tabBar.tintColor = UIColor.whiteColor()
            
            
            tbc?.tabBar.barStyle = UIBarStyle.Black
            
            print(tbc)
            
            UIApplication.sharedApplication().keyWindow?.rootViewController = tbc
            
            
        }
        
//        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
//        
//        self.navigationController?.navigationBar.tintColor = UIColor.clearColor()
//        
//         self.navigationController?.navigationBar.barTintColor = UIColor.clearColor()
//        
         self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
         self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func buttonClicked(sender:UIButton)
    {
        if sender.highlighted {
            sender.backgroundColor = UIColor.blueColor()
  
        }
    }

    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //this is the button to initiate choosing a profile pic
    @IBAction func pickImage(sender: AnyObject) {
        
        
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var pickedImage: UIImageView!
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //profileImage = scaleImage(profileImage, newSize: CGSizeMake(600, 600))
        
        
        pickedImage.image = image
        
        var resizedImage = self.resizeImage(image, toSize: CGSizeMake(100, 100))
        
        
        
        
   // create a random number
        let randomNumber = arc4random_uniform(UINT32_MAX)
        
        // create a specific string for the amazonS3 URL of our image. That string consists of our image image name with a random number.
        var photoFileName = "\(randomNumber)_avatar.png"
        
        // create a directory for storing the image and add the image name to that directory
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var filePath = paths[0] + photoFileName
        
        // create a PNG version of our image and store it in our directory
        UIImagePNGRepresentation(resizedImage)!.writeToFile(filePath, atomically: true)
        

        // take our singleton and call the postObject pre-defined method (pre-defined in the AFAmazonS3Manager class)
        // this method posts the filePath (of our directory with the image in it to the amazonS3. If successful, amazonS3 will store our image and we will have an amazonS3 link with our image in it.
        S3.model().s3Manager.postObjectWithFile(filePath, destinationPath: "", parameters: nil, progress: { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
            
                print("\(Int(CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite) * 100))% Uploaded")
            
            }, success: { (responseObject) -> Void in
                
                // if successful, we have an amazon S3 link with our image in it. The url ends with our photoFileName (the specific string we created above with a random number at the end of it). We then store the imageUrl to our registerInfo dictionary that we're going to send to Rails. We only send that Url to Rails and not the image itself.
                
                
                print(responseObject)
                
                
                // store the imageUrl to our registerInfo dictionary that we're going to send to Rails
                
                self.registerInfo["image_string"] = "https://wingmen.s3.amazonaws.com/\(photoFileName)"
                
            }) { (error) -> Void in
                
                // if error do stuff
        }
        
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func resizeImage(original : UIImage, toSize size:CGSize) -> UIImage
    {
        var imageSize:CGSize = CGSizeZero
        
        if (original.size.width < original.size.height)
        {
            
            
            imageSize.height    = size.width * original.size.height / original.size.width
            imageSize.width     = size.width
        }
        else
        {
            imageSize.height    = size.height
            imageSize.width     = size.height * original.size.width / original.size.height
        }
        
        UIGraphicsBeginImageContext(imageSize)
        // draw the new image with the imageSize.width and height (based on the UIImageView size)
        original.drawInRect(CGRectMake(0,0,imageSize.width,imageSize.height))
        
        // put the drawing in a UIImage
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
   
//    func resizeImage(orignalImage: UIImage, withSize: CGSize) {
//        
//        var scale : Float = if(originalImage.size.height > originalImage.size.width) {  size.width / originalImage.size.width } else { size.height / originalImage.size.height}
    
    
        
        /*
    -(UIImage *)resizeImage:(UIImage *) originalImage withSize: (CGSize)size {
    
    float scale = (originalImage.size.height > originalImage.size.width) ?  size.width / originalImage.size.width : size.height / originalImage.size.height;
    
    CGSize ratioSize = CGSizeMake(originalImage.size.width * scale, originalImage.size.height * scale);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [originalImage drawInRect:CGRectMake(0, 0, ratioSize.width, ratioSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
    }

    */
  
    
    
    @IBOutlet weak var createUsernameField: UITextField!
    
    @IBOutlet weak var enterEmailField: UITextField!
    
    @IBOutlet weak var createPasswordField: UITextField!
    
    @IBOutlet weak var pickProfilePicButton: UIButton!
    
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBAction func genderSC(sender: UISegmentedControl) {
        
        
        let selectedSegment = sender.selectedSegmentIndex
        if selectedSegment == 0 {
            
            registerInfo["gender"] = "male"
            print("isOff")
        
        }
        
        if selectedSegment == 1 {
            
            registerInfo["gender"] = "female"
            print("isOn")
            
        }
        
//        var segmentedControl: UISegmentedControl!
//        let selectedSegmentIndex = sender.selectedSegmentIndex
//        
//        let selectedSegmentText = sender.titleForSegmentAtIndex(selectedSegmentIndex)
//        
//        let segments = ["Male", "Female"]
//        
//        segmentedControl = UISegmentedControl(items: segments)
//        
//        segmentedControl.addTarget(self, action: "segmentedControlValueChanged:", forControlEvents: .ValueChanged)
//        
//        
//
//        
//        
//        println("Segment \(selectedSegmentIndex) with text of" + " \(selectedSegmentText) is selected")
        
    }

    @IBOutlet @IBInspectable  weak var interestField: UITextView!
    
    func popToRoot(sender:UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func goToApp() {
        
        
        let tbc = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
        
        tbc?.tabBar.tintColor = UIColor.whiteColor()
        
        
        tbc?.tabBar.barStyle = UIBarStyle.Black
        
        print(tbc)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController = tbc
        
    }
    
    func signInUnsuccesful(error: String) {
        
        
        let alert:UIAlertView = UIAlertView(title: "Error", message: error, delegate: nil, cancelButtonTitle: "Ok")
        
        alert.show()
    }
    
    func update() {
        
        let gender = registerInfo["gender"] as! String
        
        let imageUrl = registerInfo["image_string"] as! String
        
        if let userId = User.currentUser().userId {
            User.currentUser().update(gender, interests: self.interestField.text, userId: userId, imageFile:
                imageUrl)
        }
        
    }
    
    
    
    @IBAction func signUp(sender: AnyObject) {

        
  
        //how to take results from func genderSC and put it here?
      
       // user["gender"] = String(genderSC(UISegmentedControl(items: segments)))
        
        //how to save a pic in Parse?
        //user["profile pic"] =
       //user["interests"] = interestField[] or .text
        
        // other fields can be set just like with PFObject
        //user["phone"] = "415-392-0202"
        
        let fieldValues: [String] = [createUsernameField.text!, createPasswordField.text!, enterEmailField.text!, interestField.text!] //interestField.text
        
        if fieldValues.indexOf("") != nil || self.registerInfo["image_string"] == nil {
            
            //all fields are not filled in
            let alertViewController = UIAlertController(title: "Submission Error", message: "Please complete all fields", preferredStyle: UIAlertControllerStyle.Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertViewController.addAction(defaultAction)
            
            presentViewController(alertViewController, animated: true, completion: nil)
            
            
            
            
        }
            
        else {
            
            registerInfo["username"] = self.createUsernameField.text
            registerInfo["interests"] = self.interestField.text
            
       
            
            User.currentUser().signUp(createUsernameField.text!, email: enterEmailField.text!, password: createPasswordField.text!)
        }
    
    
  }

}
