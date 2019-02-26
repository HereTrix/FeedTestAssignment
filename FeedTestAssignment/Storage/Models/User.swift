//
//  User.swift
//  PostTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

import CoreData

@objc(User)
class User: NSManagedObject {

    static func entityName() -> String {
        return "User"
    }
}
