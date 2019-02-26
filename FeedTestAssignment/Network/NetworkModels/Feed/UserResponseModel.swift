//
//  UserResponseModel.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

class UserResponseModel: ResponseModel {

    var userID: String!
    var userName: String!
    
    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case userID = "user_id"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userName = try container.decode(String.self, forKey: .userName)
        userID = try container.decode(String.self, forKey: .userID)
    }
}
