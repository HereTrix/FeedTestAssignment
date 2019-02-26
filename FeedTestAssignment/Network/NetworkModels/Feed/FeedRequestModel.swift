//
//  FeedRequestModel.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

class FeedRequestModel: RequestModel {

    var offset: Int = 0
    var limit: Int = 20
    
    override func mockResponse() -> Data? {
        
        var array = [Any]()
        
        if offset > 0 {
            return try! JSONSerialization.data(withJSONObject: array, options: [])
        }
        
        for _ in 0..<limit {
            var post = [String:Any]()
            
            post["post_id"] = String.randomString(length: 8)
            post["published_at"] = Date().convertToString()
            let rand = arc4random_uniform(UInt32(Post.messageLimit))
            post["content"] = String.randomString(length: Int(rand > 0 ? rand : 1))
            
            var user = [String:String]()
            user["user_id"] = String.randomString(length: 8)
            user["user_name"] = String.randomString(length: 8)
            
            post["user"] = user
            
            array.append(post)
        }
        
        return try! JSONSerialization.data(withJSONObject: array, options: [])
    }
}
