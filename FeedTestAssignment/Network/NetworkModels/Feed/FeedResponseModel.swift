//
//  FeedResponse.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

class FeedResponseModel: ResponseModel {
    
    var postID: String!
    var content: String!
    var publishedAt: Date!
    var user: UserResponseModel!
    
    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case publishedAt = "published_at"
        case content = "content"
        case user = "user"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        postID = try container.decode(String.self, forKey: .postID)
        user = try container.decode(UserResponseModel.self, forKey: .user)
        content = try? container.decode(String.self, forKey: .content)
        
        if let stringDate = try? container.decode(String.self, forKey: .publishedAt) {
            publishedAt = Date.from(string: stringDate)
        }
    }
}
