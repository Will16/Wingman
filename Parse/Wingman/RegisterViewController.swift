//
//  RegisterViewController.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/2/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit
@IBDesignable


class RegisterViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate

{
    
   
    
    let segments = ["male", "female"]
    
    var user = PFUser()
    var registerInfo = [String:AnyObject]()
    
    var myCustomBackButtonItem: UIBarButtonItem?
    
    var customButton: UIButton?
    
    
    var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        pickProfilePicButton.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlState.Highlighted)
//        
    
    
        
        self.registerInfo["gender"] = "male"
        
        self.interestField.layer.cornerRadius = 5
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        var nav = self.navigationController?.navigationBar
        
        customButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
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
         springScaleFrom(customButton!, -100, 0, 0.5, 0.5)
 
  


        springScaleFrom(imageView!, 200, 0, 0.5, 0.5)
       
        self.logoImageView.layer.cornerRadius = 50
        self.logoImageView.clipsToBounds = true
        
        // animate the logoImageView
        var scale1 = CGAffineTransformMakeScale(0.5, 0.5)
        var translate1 = CGAffineTransformMakeTranslation(0, -100)
        self.createUsernameField.transform = CGAffineTransformConcat(scale1, translate1)
        
        spring(1) {
     
            self.createUsernameField.hidden = false
            var scale = CGAffineTransformMakeScale(1, 1)
            var translate = CGAffineTransformMakeTranslation(0, 0)
            self.createUsernameField.transform = CGAffineTransformConcat(scale, translate)
        }
        
        // animate the textViews
        
        
        var scale2 = CGAffineTransformMakeScale(0.5, 0.5)
        var translate2 = CGAffineTransformMakeTranslation(0, -100)
        self.enterEmailField.transform = CGAffineTransformConcat(scale2, translate2)
        
        spring(1) {
            self.enterEmailField.hidden = false
            var scale = CGAffineTransformMakeScale(1, 1)
            var translate = CGAffineTransformMakeTranslation(0, 0)
            self.enterEmailField.transform = CGAffineTransformConcat(scale, translate)
       
            
        }
        
        var scale3 = CGAffineTransformMakeScale(0.5, 0.5)
        var translate3 = CGAffineTransformMakeTranslation(0, -100)
        self.createPasswordField.transform = CGAffineTransformConcat(scale3, translate3)
        
        spring(1) {
            self.createPasswordField.hidden = false
            var scale = CGAffineTransformMakeScale(1, 1)
            var translate = CGAffineTransformMakeTranslation(0, 0)
            self.createPasswordField.transform = CGAffineTransformConcat(scale, translate)
       
            
        }

        
        var scale4 = CGAffineTransformMakeScale(0.5, 0.5)
        var translate4 = CGAffineTransformMakeTranslation(0, 200)
        self.pickedImage.transform = CGAffineTransformConcat(scale4, translate4)
        
        spring(1) {
            self.pickedImage.hidden = false
            var scale = CGAffineTransformMakeScale(1, 1)
            var translate = CGAffineTransformMakeTranslation(0, 0)
            self.pickedImage.transform = CGAffineTransformConcat(scale, translate)
            
            
        }
        
        if pickProfilePicButton.highlighted == true {
            pickProfilePicButton.backgroundColor = UIColor.blueColor()
            
        }
            
        if pickProfilePicButton.highlighted == false{
            pickProfilePicButton.backgroundColor = UIColor.clearColor()
        }

        
        if PFUser.currentUser() != nil {
            
            
            var tbc = storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
            
            
            tbc?.tabBar.tintColor = UIColor.whiteColor()
            
            
            tbc?.tabBar.barStyle = UIBarStyle.Black
            
            println(tbc)
            
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
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
        
        
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var pickedImage: UIImageView!
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //profileImage = scaleImage(profileImage, newSize: CGSizeMake(600, 600))
        
        
        pickedImage.image = image
        
        var resizedImage = self.resizeImage(image, toSize: CGSizeMake(100, 100))
        
        
        
        
        // tranforming it to a PFFile
        
        // image to data
        
        let imageData = UIImagePNGRepresentation(resizedImage)
        
        // data to pffile
        let imageFile = PFFile(name: "image.png", data: imageData)
   
        registerInfo["imageFile"] = imageFile
        
        
        
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
        
        
        var selectedSegment = sender.selectedSegmentIndex
        if selectedSegment == 0 {
            
            registerInfo["gender"] = "male"
            println("isOff")
        
        }
        
        if selectedSegment == 1 {
            
            registerInfo["gender"] = "female"
            println("isOn")
            
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
    
    @IBAction func signUp(sender: AnyObject) {
        
     
        
        user.username = createUsernameField.text
        user.password = createPasswordField.text
        user.email = enterEmailField.text
        
        //how to take results from func genderSC and put it here?
      
       // user["gender"] = String(genderSC(UISegmentedControl(items: segments)))
        
        //how to save a pic in Parse?
        //user["profile pic"] =
       //user["interests"] = interestField[] or .text
        
        // other fields can be set just like with PFObject
        //user["phone"] = "415-392-0202"
        
        var fieldValues: [String] = [createUsernameField.text, createPasswordField.text, enterEmailField.text, interestField.text] //interestField.text
        
        if find(fieldValues, "") != nil || self.registerInfo["imageFile"] == nil {
            
            //all fields are not filled in
            var alertViewController = UIAlertController(title: "Submission Error", message: "Please complete all fields", preferredStyle: UIAlertControllerStyle.Alert)
            
            var defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertViewController.addAction(defaultAction)
            
            presentViewController(alertViewController, animated: true, completion: nil)
            
            
            
            
        }
            
        else {
            
            registerInfo["username"] = self.createUsernameField.text
            registerInfo["interests"] = self.interestField.text
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError!) -> Void in
                if error == nil {
                    // Hooray! Let them use the app now.
                                        self.saveInfoToParse()
                    
                 
                 
                  
                    /*
                    println(user)
                    
                    self.createUsernameField.text = ""
                    self.createPasswordField.text = ""
                    self.enterEmailField.text = ""
                    //self.interestField.text = ""
                   // self.genderSC(sender: UISegmentedControl(items: segments)) = ""
                    
                    */
                }
                else
                {
                    
                    
                    if let errorString = error.userInfo?["error"] as? NSString
                    {
                        var alert:UIAlertView = UIAlertView(title: "Error", message: errorString as String, delegate: nil, cancelButtonTitle: "Ok")
                        
                        alert.show()
                    }
                        
                    else {
                        var alert:UIAlertView = UIAlertView(title: "Error", message: "Unable to create account" , delegate: nil, cancelButtonTitle: "Ok")
                        
                        alert.show()
                        
                    }
                    
                    
                }
            }
        }
    }
    
    
    
    func saveInfoToParse() {
        
        
        var query = PFQuery(className:"_User")
        
        query.whereKey("objectId", equalTo: PFUser.currentUser().objectId)
        
        
        
        
        query.findObjectsInBackgroundWithBlock() {
            (objects:[AnyObject]!, error:NSError!)->Void in
            if ((error) == nil) {
                
                
                let user:PFUser =  objects.last as! PFUser
                
                
                //this creates the registerInfo column in Parse
                user["registerInfo"] = self.registerInfo
                
                var gender = self.registerInfo["gender"] as! String?
                user["gender"] = gender
                
                user["postData"] = ["name": "JOHN", "AGE": "12"]
                user.saveInBackground()
                
                
                var tbc = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
                
                tbc?.tabBar.tintColor = UIColor.whiteColor()
                
                
                tbc?.tabBar.barStyle = UIBarStyle.Black
                
                println(tbc)
                
                UIApplication.sharedApplication().keyWindow?.rootViewController = tbc
                
                
                    
                }
                
                
            }
    }

}
