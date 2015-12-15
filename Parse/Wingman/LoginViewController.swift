//
//  ViewController.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/1/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, CLLocationManagerDelegate  {
    
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var gravityBehavior: UIGravityBehavior!
    var snapBehavior: UISnapBehavior!
    
    
    var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        GlobalVariableSharedInstance.startUpdatingLocation()
        
        animator = UIDynamicAnimator(referenceView: view)
        
        self.logoImageView.layer.cornerRadius = 50
        self.logoImageView.clipsToBounds = true
        
        
    
        
        
        
        // hides navigation bar on LoginVC
        //  self.navigationController?.setNavigationBarHidden(true, animated: true)
        //sets navigation bar to a clear black color
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        self.navigationController?.navigationBarHidden = false
        //sets navigation bar's "Back" button item to white
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        
        
        imageView = UIImageView(frame: CGRect(x: -80, y: 0, width: 300, height: 40))
        
        
        imageView!.clipsToBounds = true
        
        imageView!.contentMode = .ScaleAspectFill
        
        imageView!.hidden = true
        let image = UIImage(named: "bar")
        
        imageView!.image = image
        navigationItem.titleView = imageView

        
    }
    
    
    override func viewWillAppear(animated: Bool) {


        self.logoImageView.hidden = true
        self.loginButton.hidden = true
        self.signInButton.hidden = true
        
        self.imageView!.hidden = true
    }
    override func viewDidAppear(animated: Bool) {
        
        
    
        self.logoImageView.layer.cornerRadius = 50
         self.logoImageView.clipsToBounds = true
       
        self.imageView!.hidden = false
        springScaleFrom(self.imageView!, x: 0, y: -100, scaleX: 0.5, scaleY: 0.5)
        
        
        

        
        
      
        
        
        // animate the logoImageView
        let scale1 = CGAffineTransformMakeScale(0.5, 0.5)
        let translate1 = CGAffineTransformMakeTranslation(0, 500)
        self.logoImageView.transform = CGAffineTransformConcat(scale1, translate1)
        
        animationWithDuration(4) {
             self.logoImageView.hidden = false
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.logoImageView.transform = CGAffineTransformConcat(scale, translate)
        }

         // animate the textViews
        
        
        let scale2 = CGAffineTransformMakeScale(0.5, 0.5)
        let translate2 = CGAffineTransformMakeTranslation(-300, 0)
        self.loginButton.transform = CGAffineTransformConcat(scale2, translate2)
        
        spring(1) {
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.loginButton.transform = CGAffineTransformConcat(scale, translate)
            self.loginButton.hidden = false

        }
        
        let scale3 = CGAffineTransformMakeScale(0.5, 0.5)
        let translate3 = CGAffineTransformMakeTranslation(300, 0)
        self.signInButton.transform = CGAffineTransformConcat(scale3, translate3)
        
        spring(1) {
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.signInButton.transform = CGAffineTransformConcat(scale, translate)
            self.signInButton.hidden = false

        }


        

        if PFUser.currentUser() != nil {
            
            let tbc = storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
            
            tbc?.tabBar.tintColor = UIColor.whiteColor()

            
            tbc?.tabBar.barStyle = UIBarStyle.Black
            
            print(tbc)
            
            UIApplication.sharedApplication().keyWindow?.rootViewController = tbc
        }
////        
////        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        
 //        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
     
        
        
    }
    
    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signInButton: UIButton!
    
    
    @IBAction func loginButton(sender: AnyObject) {
        
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        
        let fieldValues: [String] = [usernameField.text!, passwordField.text!]
        
        if fieldValues.indexOf("") != nil {
            
            //all fields are not filled in
            let alertViewController = UIAlertController(title: "Submission Error", message: "Please complete all fields", preferredStyle: UIAlertControllerStyle.Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertViewController.addAction(defaultAction)
            
            presentViewController(alertViewController, animated: true, completion: nil)
        }
            
    
        
        else {
            
            PFUser.logInWithUsernameInBackground(usernameField.text, password:passwordField.text) {
                (user: PFUser!, error: NSError!) -> Void in
                
                
                if (user != nil) {
                    // need to go to tabBarController
                    
                    
                    
                    //all fields are filled in
                    print("All fields are filled in and login complete")
                    
                    
                    let userQuery = PFUser.query()
                    userQuery.whereKey("username", equalTo: self.usernameField.text)
                    
                    userQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        
                        if objects.count > 0 {
                            
                            self.isLoggedIn = true
                            self.checkIfLoggedIn()
                            
                        } else {
                            
//                            self.signUp()
                        }
                    })
                    
                } else {
                    if let errorString = error.userInfo["error"] as? NSString
                    {
                        let alert:UIAlertView = UIAlertView(title: "Error", message: errorString as String, delegate: nil, cancelButtonTitle: "Ok")
                        
                        alert.show()
                    }
                        
                    else {
                        let alert:UIAlertView = UIAlertView(title: "Error", message: "Unable to login" , delegate: nil, cancelButtonTitle: "Ok")
                        
                        alert.show()
                        
                    }
                    
                    
                    
                }
                
            
            }
        }
    }

    
    var isLoggedIn: Bool {
        
        get {
            
            return NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn")
            
        }
        
        set {
            
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "isLoggedIn")
            
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
    }
        

    func checkIfLoggedIn(){
        
        print(isLoggedIn)
        
        if isLoggedIn {
            
            //replace this controller with the tabbarcontroller
            
            
            
            
            
            let tbc = storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
            
            tbc?.tabBar.tintColor = UIColor.whiteColor()
            
            
            tbc?.tabBar.barStyle = UIBarStyle.Black
            
            print(tbc)
            
            UIApplication.sharedApplication().keyWindow?.rootViewController = tbc
        }
        
        
    }

  
  
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    view.endEditing(true)
    super.touchesBegan(touches, withEvent: event)
    }
    

 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

