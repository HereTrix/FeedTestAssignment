//
//  RequestModel.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

class RequestModel {

    var path: String = ""
    var requestType: RequestType = .GET
    
    func createRequest() -> Request {
        let request = Request()
        request.path = path
        request.method = requestType
        if let json = toJSON() {
            request.data = try! JSONSerialization.data(withJSONObject: json, options: [])
        }
        
        return request
    }
    
    func toJSON() -> [String:Any]? {
        return nil
    }
    
    func mockResponse() -> Data? {
        return nil
    }
}
