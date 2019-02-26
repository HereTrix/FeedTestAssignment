//
//  LoginRequestModel.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

class LoginRequestModel: RequestModel {

    var email: String
    var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
        super.init()
        
        requestType = .POST
    }
    
    override func toJSON() -> [String : Any]? {
        return ["email":email, "password":password]
    }
    
    override func mockResponse() -> Data? {
        
        // Simulate "wrong" password
        if password == "wrong" {
            return nil
        }
        
        var dict = [String:Any]()
        
        dict["token"] = String.randomString(length: 8)
        dict["user_id"] = String.randomString(length: 8)
        dict["user_name"] = email
        
        return try! JSONSerialization.data(withJSONObject: dict, options: [])
    }
}
