//
//  File.swift
//  Wingman
//
//  Created by William McDuff on 2015-03-26.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import Foundation
//import AFAmazonS3Manager

let s3URL = "https://s3.amazonaws.com/BUCKET/"


// singleton
private let _S3Model = S3()

// create a directory where we can store the images
let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 

class S3 {
    
    // class func to return the singleton
    class func model() -> S3 { return _S3Model }
    
    // the manager
    var s3Manager: AFAmazonS3Manager {
        
        // create a manager with our id and our secret
        let manager = AFAmazonS3Manager(accessKeyID: "AKIAIVV7LIB77YFJ4N2A", secret: "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")
        manager.requestSerializer.region = AFAmazonS3USStandardRegion
        // the bucket is the name of our app
        manager.requestSerializer.bucket = "wingmen"
        return manager
        
    }
    
}
