//
//  PostResponseModel.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

class PostResponseModel: ResponseModel {
    
    var content: String
    var postID: String
    var publishedAt: Date?
    var user: UserResponseModel
    
    enum CodingKeys: String, CodingKey {
        case content = "content"
        case postID = "post_id"
        case publishedAt = "published_at"
        case user = "user"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decode(String.self, forKey: .content)
        postID = try container.decode(String.self, forKey: .postID)
        
        if let stringDate = try? container.decode(String.self, forKey: .publishedAt) {
            publishedAt = Date.from(string: stringDate)
        }
        
        user = try container.decode(UserResponseModel.self, forKey: .user)
    }
}
