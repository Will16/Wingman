//
//  User.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/20/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import Foundation

import UIKit


protocol SignedInProtocol {
    func goToApp()
    func signInUnsuccesful(error: String)
    func update()
    
    
}

protocol didPostEventProtocol {
    func didReceiveEvent()
    func didNotReceiveEvent(error: String?)
}

protocol didGetEventsProtocol {
    func didGetAllEvents(events: [[String: AnyObject]])
    func didNotGetAllEvents(error: String?)
}

private let _currentUser = User()
// properties like token, email, password. We pass the token to the request class and when api receive after completion resend to the user class

class User {
    
    var registerDelegate: RegisterViewController?
    
    var loginDelegate: LoginViewController?
    
    var postEventDelegate: PostViewController?
    
    var getEventsDelegate: BrowseTableViewController?
    
    var token: String? {
        
        didSet {
            
            
            
            // do that so we can get that token value when we open the app
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setObject(token, forKey: "token")
            
            // synchronize = save
            defaults.synchronize()
        }
        
    }
    
    var userId: Int? {
        
        didSet {
            
            
            
            // do that so we can get that token value when we open the app
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setObject(userId, forKey: "userId")
            
            // synchronize = save
            defaults.synchronize()
        }
        
    }

    
    var email: String?
    
    var phoneNumber: String?
    
    init() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        token = defaults.objectForKey("token") as? String
 
    }
    
    // getter: will return our singleton object
    class func currentUser() -> User {
        return _currentUser
    }
    
    
    // Change To GET INSTEAD OF POST
    func signUp(username: String, email: String, password: String) {
        
        
        // the key names are for us (we chose the name of the keynames, the values are going to be used for url request)
        let options: [String:AnyObject] = [
            
            "endpoint": "/users",
            "method": "POST",
            "body": [
                
                "user": [ "username": username, "email": email, "password": password ]
                
                
            ]
        ]
        
        
        // responseInfo will be set at the end of the requestwithoptions function: (completion: requestWithoptions), then we will print responseInfo
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo, error) -> () in
            
            
            // println(responseInfo)
            
            if error != nil {
                
                print("Error != nil")
                self.registerDelegate?.signInUnsuccesful(error!)
            }
                
            else {
                
                
                print(responseInfo)
                
                if let responseInfo: AnyObject = responseInfo as AnyObject? {
                    print(responseInfo)
                if let dataInfo: AnyObject = responseInfo["user"] {
                    if let token = dataInfo["authentication_token"] as? String {
                        self.token = token
                    }
                    
                    if let userId = responseInfo["user_id"] as? Int {
                        self.userId = userId
                        
                        self.registerDelegate?.update()
                    }

                    
                }
                    
                else {
                   
                    self.registerDelegate?.signInUnsuccesful(responseInfo.description)
                }
            }
            
            // do something here after request is done
            }
        })
}

    func signIn(username: String, password: String) {
        
        
        // the key names are for us (we chose the name of the keynames, the values are going to be used for url request)
        let options: [String:AnyObject] = [
            
            "endpoint": "/users/sign_in",
            "method": "POST",
            "body": [
                
                "user": [ "username": username, "password": password ]
                
                
            ]
        ]
        
        
        // responseInfo will be set at the end of the requestwithoptions function: (completion: requestWithoptions), then we will print responseInfo
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo, error) -> () in
            
         
            if error != nil {
                
                print("Error != nil")
                self.loginDelegate?.signInUnsuccesful(error!)
            }
            else {
                
              
                   print("WHAT")
                if let responseInfo: AnyObject = responseInfo as AnyObject? {
                      print(responseInfo)
                    if let dataInfo: AnyObject = responseInfo["user"] {
                        if let token = dataInfo["authentication_token"] as? String {
                            self.token = token
                            self.loginDelegate?.goToApp()
                            
                            /*
                            
                            if let userId = responseInfo!["user_id"] as? Int {
                            self.userId = userId
                            
                            self.loginDelegate?.goToApp()
                            
                            }
                            
                            */
                            
                        }
                        
                        
                        
                        
                    }
                        
                    else {
                        
                        print("No data Info")
                        
                        self.loginDelegate?.signInUnsuccesful(responseInfo.description)
                    }

                }
            }
            
            // do something here after request is done
            
        })
}
    
    func update(gender: String, interests: String, userId: Int, imageFile: String) {
        
        print("THIS SHOULD BE OUR USERID: \(userId)")
        print("THIS SHOULD BE OUR TOKEN: \(self.token)")
        
        // the key names are for us (we chose the name of the keynames, the values are going to be used for url request)
        let options: [String:AnyObject] = [
            
            "endpoint": "/users/\(userId)",
            "method": "PUT",
            "body": [
                
                "user": [ "gender": gender, "interests": interests, "image_string": imageFile]
               // "user": [ "gender": gender, "interests": interests, "avatar": userImage]
                
                
            ]
        ]
        
        
        // responseInfo will be set at the end of the requestwithoptions function: (completion: requestWithoptions), then we will print responseInfo
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo, error) -> () in
            if error != nil {
                
                print("Error != nil")
                self.loginDelegate?.signInUnsuccesful(error!)
            } else {
                
                if let responseInfo: AnyObject = responseInfo as AnyObject? {
                    print(responseInfo)
                    
                    
                    if let dataInfo: AnyObject = responseInfo["user"] {
                        
                        print("Successful")
                        
                        self.loginDelegate?.goToApp()
                        
                        
                        
                        
                    } else {
                        
                        print("Error")
                        
                    }
                }
                
            }
            // do something here after request is done
            
        })
    }
    
    
    func postEvent(venueName: String, latitude: Float, longitude: Float, startTime: String, endTime: String, wingmanGender: String) {
        
        let options: [String: AnyObject] = [
            
            "endpoint": "/events",
            "method": "POST",
            "body": [
            
                "event": ["venue": venueName, "latitude": latitude, "longitude": longitude, "start_time_string": startTime, "end_time_string": endTime, "wingman_gender": wingmanGender]
                
                
            ]
        ]
        
        
        // responseInfo will be set at the end of the requestwithoptions function: (completion: requestWithoptions), then we will print responseInfo
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo, error) -> () in
            if error != nil {
                
                print("Error != nil")
               self.postEventDelegate?.didNotReceiveEvent(error)
            } else {
                
                
                if let responseInfo: AnyObject = responseInfo as AnyObject? {
                    print(responseInfo)
           
                if let dataInfo: AnyObject = responseInfo["event"] {
                    
                    print("Successful")
                     self.postEventDelegate?.didReceiveEvent()
                    
                    
                    
                    
                    
                } else {
                    
                    print("Error")
                    self.postEventDelegate?.didNotReceiveEvent(responseInfo.description)
                    
                }
            }
            
            // do something here after request is done
            }
        })
        
    }
    
    
    func getEvents() {
        
        let options: [String: AnyObject] = [
            
            "endpoint": "/events",
            "method": "GET",
            "body": [
                
                
                
            ]
        ]
        
        
        // responseInfo will be set at the end of the requestwithoptions function: (completion: requestWithoptions), then we will print responseInfo
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo, error) -> () in
            if error != nil {
                
                print("Error != nil")
                  self.getEventsDelegate?.didNotGetAllEvents(error)
                // self.delegate2?.signInUnsuccesful(error!)
            }
            else {
                
                if let responseInfo: AnyObject = responseInfo as AnyObject? {
                    print(responseInfo)
              
                
                if let dataInfo: AnyObject = responseInfo["events"] {
                    
                    if let events = dataInfo as? [[String: AnyObject]] {
                        
                       self.getEventsDelegate?.didGetAllEvents(events)
                        
                    }
                    
                    
                    print("Successful")
                    
                
                    
                    
                    
                    
                }
                    
                else {
                    self.getEventsDelegate?.didNotGetAllEvents(responseInfo.description)
                }
            }
            }
            // do something here after request is done
            
        })
        
    }
    
    
    
    
    
    
    
    
    /*

        func sendNewJob(jobDict: Dictionary<String, AnyObject>, authToken: String) {
    
        // the key names are for us (we chose the name of the keynames, the values are going to be used for url request)
        let options: [String:AnyObject] = [
            
            "endpoint": "/users/listings",
            "method": "POST",
            "body": [
                "auth_token": authToken,
                "listing": jobDict
                
                
                
                
            ]
        ]
        
        
        // responseInfo will be set at the end of the requestwithoptions function: (completion: requestWithoptions), then we will print responseInfo
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo, error) -> () in
            if error != nil {
                
                println("Error != nil")
                self.delegate?.signInUnsuccesful(error!)
            } else {
                
                //      println("THIS IS THE RESPONSEINFO: \(responseInfo)")
                if let dataInfo: AnyObject = responseInfo!["listing"] {
                    if let token = dataInfo["authentication_token"] as? String {
                        self.token = token
                    }
                    
                    if let delegate = self.delegate2 {
                        delegate.goToApp()
                    }
                    
                } else {
                    
                    println("No data Info")
                    
                    self.delegate2?.signInUnsuccesful(responseInfo!.description)
                }
            }
            
            // do something here after request is done
            
        })
        
        
    }
    
    func getUserListings(authToken: String, completion: (listings:[[String:AnyObject]]) -> ()) {
        
        // the key names are for us (we chose the name of the keynames, the values are going to be used for url request)
        let options: [String:AnyObject] = [
            
            "endpoint": "/users/listings",
            "method": "GET",
            
        ]
        
        
        // responseInfo will be set at the end of the requestwithoptions function: (completion: requestWithoptions), then we will print responseInfo
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo, error) -> () in
            if error != nil {
                
                println("Error != nil")
                //  self.delegate?.signInUnsuccesful(error!)
            } else {
                
                
                
                if let listings = responseInfo?["listings"] as? [[String:AnyObject]] {
                    
                    
                    
                    completion(listings: listings)
                    
                    
                    //        if let delegate = self.delegate2 {
                    //          delegate.goToApp()
                    //    }
                    
                } else {
                    
                    println("No data Info")
                    
                    //self.delegate2?.signInUnsuccesful(responseInfo!.description)
                }
            }
            
            
            // do something here after request is done
            
        })
        
        
}
    func getPreInterviewChecklist(jobDict: Dictionary<String, AnyObject>, listingId: Int) {
        
        // the key names are for us (we chose the name of the keynames, the values are going to be used for url request)
        let options: [String:AnyObject] = [
            
            "endpoint": "/users/listings/\(listingId)/preinterview",
            "method": "GET",
            "body": [
                "listing": jobDict
                
                
                
                
            ]
        ]
        
        
        // responseInfo will be set at the end of the requestwithoptions function: (completion: requestWithoptions), then we will print responseInfo
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo, error) -> () in
            if error != nil {
                
                println("Error != nil")
                self.delegate?.signInUnsuccesful(error!)
            } else {
                
                println(responseInfo!)
                
                if let dataInfo: AnyObject = responseInfo!["preinterview"] {
                    
                    
                    if let delegate = self.delegate2 {
                        delegate.goToApp()
                    }
                    
                } else {
                    
                    
                    println("No data Info")
                    
                    self.delegate2?.signInUnsuccesful(responseInfo!.description)
                }
            }
            
            // do something here after request is done
            
        })
        
        
    }
    
    
    func deleteListing(jobDict: Dictionary<String, AnyObject>, listingId: Int) {
        
        // the key names are for us (we chose the name of the keynames, the values are going to be used for url request)
        let options: [String:AnyObject] = [
            
            "endpoint": "/users/listings/\(listingId)",
            "method": "DELETE",
            "body": [
                "listing": jobDict
                
                
                
                
            ]
        ]
        
        
        // responseInfo will be set at the end of the requestwithoptions function: (completion: requestWithoptions), then we will print responseInfo
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo, error) -> () in
            if error != nil {
                
                println("Error != nil")
                self.delegate?.signInUnsuccesful(error!)
            } else {
                
                println(responseInfo!)
                
                if let dataInfo: AnyObject = responseInfo!["message"] {
                    
                    
                    if let delegate = self.delegate2 {
                        delegate.goToApp()
                    }
                    
                } else {
                    
                    
                    println("No data Info")
                    
                    self.delegate2?.signInUnsuccesful(responseInfo!.description)
                }
            }
            
            // do something here after request is done
            
        })
        
}
    func editListing(jobDict: Dictionary<String, AnyObject>, authToken: String, listingId: Int) {
        
        // the key names are for us (we chose the name of the keynames, the values are going to be used for url request)
        let options: [String:AnyObject] = [
            
            "endpoint": "/users/listings/\(listingId)",
            "method": "PATCH",
            "body": [
                "auth_token": authToken,
                "listing": jobDict
                
                
                
                
            ]
        ]
        
        
        // responseInfo will be set at the end of the requestwithoptions function: (completion: requestWithoptions), then we will print responseInfo
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo, error) -> () in
            if error != nil {
                
                println("Error != nil")
                self.delegate?.signInUnsuccesful(error!)
            } else {
                
                //  println(responseInfo!)
                if let dataInfo: AnyObject = responseInfo!["listing"] {
                    if let token = dataInfo["authentication_token"] as? String {
                        self.token = token
                    }
                    
                    if let delegate = self.delegate2 {
                        delegate.goToApp()
                    }
                    
                } else {
                    
                    println("No data Info")
                    
                    self.delegate2?.signInUnsuccesful(responseInfo!.description)
                }
            }
            
            // do something here after request is done
            
        })
        
        
    }
    
    
    
    // DO EDIT AND GET ON
    
    func getOneListing(jobDict: Dictionary<String, AnyObject>, authToken: String) {
        
        // the key names are for us (we chose the name of the keynames, the values are going to be used for url request)
        let options: [String:AnyObject] = [
            
            "endpoint": "/users/listings/",
            "method": "GET",
            "header": [
                "auth_token": authToken,
            ]
            
        ]
        
        
        // responseInfo will be set at the end of the requestwithoptions function: (completion: requestWithoptions), then we will print responseInfo
        APIRequest.requestWithOptions(options, andCompletion: { (responseInfo, error) -> () in
            if error != nil {
                
                println("Error != nil")
                self.delegate?.signInUnsuccesful(error!)
            } else {
                
                // println(responseInfo!)
                if let dataInfo: AnyObject = responseInfo!["listings"] {
                    
                    
                    if let delegate = self.delegate2 {
                        delegate.goToApp()
                    }
                    
                } else {
                    
                    println("No data Info")
                    
                    self.delegate2?.signInUnsuccesful(responseInfo!.description)
                }
            }
            
            // do something here after request is done
            
        })
        
        
    }


*/
    
    
}














