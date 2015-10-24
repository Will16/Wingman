//
//  FourSquareAPI.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/10/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import Foundation
import CoreLocation

let API_URL = "https://api.foursquare.com/v2/"
let CLIENT_ID = "YMDIMRRGBX5CKCZJ2AAUTC55WM0AU1SCDF51BF44BO4R0QKZ"
let CLIENT_SECRET = "IINAUZ21MM5HWEUAKLTDQDLSKWZGLK5TRHEK1S4ZA2XHVACU"
let version = "20150310"

protocol FoursquareAPIProtocol {
    
    func didReceiveVenues(results: [ClubOrBarVenues])
    
}

class FourSquareAPI: NSObject {
    
    let radiusInMeters = 100000 //foursquare max radius is 100k meters
    let categoryId = "4d4b7105d754a06376d81259"
    
    let data = NSMutableData()
    var delegate: PickerViewController?
    
    func searchForClubOrBarAtLocation(userLocation: CLLocation) {
        
        print("run method")
        
        let urlPath = "\(API_URL)venues/search?ll=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&limit=100&categoryId=\(categoryId)&radius=\(radiusInMeters)&client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=\(version)"
        
        print(urlPath)
        
        let url = NSURL(string: urlPath)
        let request = NSURLRequest(URL: url!)
        
        let session: NSURLSession = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            print("create session")
            
            
            
            do {
                
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                if((error) != nil) {
                    print(error!.localizedDescription)
                }
                    
                else {
                    var venues = [ClubOrBarVenues]()
                    
                    if json!.count>0 {
                        if let response: NSDictionary = json!["response"] as? NSDictionary {
                            
                            print("\(response)")
                            
                            let allVenues: [NSDictionary] = response["venues"] as! [NSDictionary]
                            
                            for venue:NSDictionary in allVenues {
                                var venueName:String = venue["name"] as! String
                                
                                var location:NSDictionary = venue["location"] as! NSDictionary
                                var venueLocation:CLLocation = CLLocation(latitude: location["lat"] as! Double, longitude: location["lng"] as! Double)
                                
                                venues.append(ClubOrBarVenues(name: venueName, location: venueLocation, distanceFromUser: venueLocation.distanceFromLocation(userLocation)))
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.delegate?.didReceiveVenues(venues)
                            print(venues)
                            
                        })
                        
                    }
                    
                }

                
            }
            catch let error as NSError {
                print("JSON Error: \(error.localizedDescription)")
            }
            
                   })
        
        task.resume()
    }
    
    
}