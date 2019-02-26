//
//  Request.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

private let baseURLLink = "https://some.site.com"

enum RequestType: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case HEAD = "HEAD"
}

class Request {

    static let baseURL = NSURL(string: baseURLLink)!
    var method: RequestType = .GET
    var path: String = ""
    var data: Data?
    var queryParams: [String: String] = [:]
    var headers: [String: String] = [:]
    var isAuthUse = false
    var skipResponseDecoding = false
    
    func addAuthHeader(token: String?) {
        guard let token = token else {
            return
        }
        isAuthUse = true
        self.headers["Authorization"] = "Bearer \(token)"
    }
    
    func createRequest() -> URLRequest {
        
        let url = Request.baseURL.appendingPathComponent(path)!
        
        let urlWithQueries = !queryParams.isEmpty ? url.withQueries(queryParams) ?? url : url
        
        var request = URLRequest(url: urlWithQueries)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = data
        
        return request
    }
}
