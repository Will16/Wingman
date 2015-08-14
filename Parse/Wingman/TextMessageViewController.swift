//
//  TextMessageViewController.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/14/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit
import MessageUI

class TextMessageViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    var phoneNumber: String?
   
    
    
    @IBAction func messageUser(sender: AnyObject) {
        
       
        if MFMessageComposeViewController.canSendText() {
            let messageController:MFMessageComposeViewController = MFMessageComposeViewController()
            
            
            if let phoneNumber = self.phoneNumber as String? {
                messageController.recipients = ["\(phoneNumber)"]
                messageController.messageComposeDelegate = self
                
                self.presentViewController(messageController, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
