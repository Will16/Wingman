//
//  APIRequest.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/20/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import Foundation

// amazon s3 buckets save images, cached images

let RAILS_URL = "https://cryptic-mesa-8497.herokuapp.com"

var email: String?






class APIRequest {
    
    
   


    
    // (responseInfo: [String:AnyObject]) -> ()
    
    // that class func gets called in the user class
    
    //from options, take the body string, change it in json and the nchange the json to data
    
    // USEFULNESS OF BLOCKS VS CREATING A FUNCTION AT THE END: WITH BLOCK, CAN DO SOMETHING SPECIFIC AT THEN END EVERYTIME WE CALL A FUNCTION
    class func requestWithOptions(options: [String: AnyObject], andCompletion completion: (responseInfo: [String:AnyObject]?, error: String?) -> ()) {
        
        
        // wrapping it in a parenthesis otherwise the + sign doesn't see the as String
        // the url + users
        var url = NSURL(string: RAILS_URL + (options["endpoint"] as! String))
        var request = NSMutableURLRequest(URL: url!)
        
        // method is post
        request.HTTPMethod = options["method"] as! String
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        //let boundary = self.generateBoundaryString()
        
        //request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        
        if let token = User.currentUser().token {
            
            request.setValue(token, forHTTPHeaderField: "authentication-token")
            
        }
        
        
        switch request.HTTPMethod {
            
        case "GET" :
            
            print("GET", terminator: "")
            
        default :
            
            let bodyInfo = options["body"] as! [String: AnyObject]
            
            let requestData = try? NSJSONSerialization.dataWithJSONObject(bodyInfo, options: NSJSONWritingOptions())
            
            let jsonString = NSString(data: requestData!, encoding: NSUTF8StringEncoding)
            
            let postLength = "\(jsonString!.length)"
            
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            
            let postData = jsonString?.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
            
            request.HTTPBody = postData
            
            
        }
        
        
        
        // mainQueue is not the main thread (just a queue)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if error == nil {
                
                // do something with data
                
                
                // mutable containers so we can change something with it
                let json = (try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)) as? [String:AnyObject]
                
                // WE CALL THE COMPLETION BLOCK
                completion(responseInfo: json, error: nil)
                
            }
                
            else {
                
                
                var errorString =  error!.description
                
                //completion(responseInfo: nil, error: errorString)
                print(errorString)
                
                
            }
            
        }
        
}

  
    
}
