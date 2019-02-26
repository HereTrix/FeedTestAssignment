//
//  LoginResponseModel.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

class LoginResponseModel: ResponseModel {
    
    var token: String
    var userID: String?
    var userName: String?
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
        case userID = "user_id"
        case userName = "user_name"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
        userID = try? container.decode(String.self, forKey: .userID)
        userName = try? container.decode(String.self, forKey: .userName)
    }
}
