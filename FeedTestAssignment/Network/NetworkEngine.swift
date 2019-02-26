//
//  NetworkEngine.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/26/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

protocol NetworkEngine {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    func executeRequest(for model: RequestModel, completionHandler: @escaping Handler)
}

class FakeNetworkEngine: NetworkEngine {
    
    func executeRequest(for model: RequestModel, completionHandler: @escaping Handler) {
        
        let request = model.createRequest()
        let httpRequest = request.createRequest()
        
        guard let url = httpRequest.url else {
            let error = NSError(domain: "FakeNetworkEngine", code: -999, userInfo: [NSLocalizedDescriptionKey: "Unsupported URL"])
            completionHandler(nil, nil, error)
            return
        }
        
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let data = model.mockResponse()
        
        completionHandler(data, response, nil)
    }
}
