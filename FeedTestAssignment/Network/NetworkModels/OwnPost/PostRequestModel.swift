//
//  PostRequestModel.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

class PostRequestModel: RequestModel {

    var text: String?
    
    override init() {
        
        super.init()
        path = "feed"
        requestType = .POST
    }
    
    override func createRequest() -> Request {
        let request = super.createRequest()
        request.addAuthHeader(token: CurrentUser.token)
        
        return request
    }
    
    override func toJSON() -> [String : Any] {
        var json = [String:Any]()
        json["text"] = text
        return json
    }
    
    override func mockResponse() -> Data? {
        
        var dict = [String:Any]()
        dict["content"] = text
        dict["post_id"] = String.randomString(length: 8)
        dict["published_at"] = Date().convertToString()
        
        var user: [String:String] = [:]
        user["user_id"] = CurrentUser.userID
        user["user_name"] = CurrentUser.userName
        
        dict["user"] = user
        
        return try! JSONSerialization.data(withJSONObject: dict, options: [])
    }
}
