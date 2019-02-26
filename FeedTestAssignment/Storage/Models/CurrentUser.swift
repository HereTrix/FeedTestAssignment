//
//  CurrentUser.swift
//  PostTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

import KeychainSwift

// MARK: - Storage keys
private let tokenKey = "tokenKey"
private let userKey = "userIDKey"
private let userNameKey = "userNameKey"

class CurrentUser {

    // MARK: - properties
    static private let keychain = KeychainSwift()
    
    static var token: String? {
        set {
            if let token = newValue {
                keychain.set(token, forKey: tokenKey)
            } else {
                keychain.delete(tokenKey)
            }
        }
        
        get {
            return keychain.get(tokenKey)
        }
    }
    
    static var userID: String? {
        set {
            if let user = newValue {
                keychain.set(user, forKey: userKey)
            } else {
                keychain.delete(userKey)
            }
        }
        
        get {
            return keychain.get(userKey)
        }
    }
    
    static var userName: String? {
        set {
            if let userName = newValue {
                keychain.set(userName, forKey: userNameKey)
            } else {
                keychain.delete(userNameKey)
            }
        }
        
        get {
            return keychain.get(userNameKey)
        }
    }
    
    static var isLoggedIn: Bool {
        return token != nil
    }
    
    // MARK: - Functions
    class func clear() {
        token = nil
        userID = nil
    }
}
