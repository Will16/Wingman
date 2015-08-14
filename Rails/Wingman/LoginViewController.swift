//
//  ViewController.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/1/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, SignedInProtocol {
    
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var gravityBehavior: UIGravityBehavior!
    var snapBehavior: UISnapBehavior!
    
    
    var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
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

    
                User.currentUser().loginDelegate = self
        
    }
    
    
    override func viewWillAppear(animated: Bool) {

        self.logoImageView.hidden = true
        self.loginButton.hidden = true
        self.signInButton.hidden = true
        
        self.imageView!.hidden = true
    }
    override func viewDidAppear(animated: Bool) {
        
        
        var nav = self.navigationController?.navigationBar
        
   
        self.logoImageView.layer.cornerRadius = 50
         self.logoImageView.clipsToBounds = true
       
        self.imageView!.hidden = false
        springScaleFrom(self.imageView!, 0, -100, 0.5, 0.5)
        
        
      
        
        
        // animate the logoImageView
        var scale1 = CGAffineTransformMakeScale(0.5, 0.5)
        var translate1 = CGAffineTransformMakeTranslation(0, 500)
        self.logoImageView.transform = CGAffineTransformConcat(scale1, translate1)
        
        animationWithDuration(4) {
             self.logoImageView.hidden = false
            var scale = CGAffineTransformMakeScale(1, 1)
            var translate = CGAffineTransformMakeTranslation(0, 0)
            self.logoImageView.transform = CGAffineTransformConcat(scale, translate)
        }

         // animate the textViews
        
        
        var scale2 = CGAffineTransformMakeScale(0.5, 0.5)
        var translate2 = CGAffineTransformMakeTranslation(-300, 0)
        self.loginButton.transform = CGAffineTransformConcat(scale2, translate2)
        
        spring(1) {
            var scale = CGAffineTransformMakeScale(1, 1)
            var translate = CGAffineTransformMakeTranslation(0, 0)
            self.loginButton.transform = CGAffineTransformConcat(scale, translate)
            self.loginButton.hidden = false

        }
        
        var scale3 = CGAffineTransformMakeScale(0.5, 0.5)
        var translate3 = CGAffineTransformMakeTranslation(300, 0)
        self.signInButton.transform = CGAffineTransformConcat(scale3, translate3)
        
        spring(1) {
            var scale = CGAffineTransformMakeScale(1, 1)
            var translate = CGAffineTransformMakeTranslation(0, 0)
            self.signInButton.transform = CGAffineTransformConcat(scale, translate)
            self.signInButton.hidden = false

        }


        

        if let token = User.currentUser().token{
            
            var tbc = storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
            
            tbc?.tabBar.tintColor = UIColor.whiteColor()

            
            tbc?.tabBar.barStyle = UIBarStyle.Black
            
            println(tbc)
            
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
        
        var fieldValues: [String] = [usernameField.text, passwordField.text]
        
        if find(fieldValues, "") != nil {
            
            //all fields are not filled in
            var alertViewController = UIAlertController(title: "Submission Error", message: "Please complete all fields", preferredStyle: UIAlertControllerStyle.Alert)
            
            var defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertViewController.addAction(defaultAction)
            
            presentViewController(alertViewController, animated: true, completion: nil)
        }
            
    
        
        else {
            
             User.currentUser().signIn(usernameField.text, password: passwordField.text)
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
        
        println(isLoggedIn)
        
        if isLoggedIn {
            
            //replace this controller with the tabbarcontroller
            
            
            
            
            
            var tbc = storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
            
            tbc?.tabBar.tintColor = UIColor.whiteColor()
            
            
            tbc?.tabBar.barStyle = UIBarStyle.Black
            
            println(tbc)
            
            UIApplication.sharedApplication().keyWindow?.rootViewController = tbc
        }
        
        
    }

  
  
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func goToApp() {
        
        
        var tbc = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
        
        tbc?.tabBar.tintColor = UIColor.whiteColor()
        
        
        tbc?.tabBar.barStyle = UIBarStyle.Black
        
        println(tbc)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController = tbc
        
    }

    func signInUnsuccesful(error: String) {
        
        
        var alert:UIAlertView = UIAlertView(title: "Error", message: error, delegate: nil, cancelButtonTitle: "Ok")
        
        alert.show()
    }

    func update() {
        
    }
}

