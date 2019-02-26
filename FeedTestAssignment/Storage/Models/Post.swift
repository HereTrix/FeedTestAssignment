//
//  Post.swift
//  PostTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

import CoreData

@objc(Post)
class Post: NSManagedObject {

    static let messageLimit = 140
    
    static func entityName() -> String {
        return "Post"
    }
}
