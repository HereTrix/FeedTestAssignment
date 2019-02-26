//
//  NetworkManager.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

typealias FailureResponseBlock = (( _ error: Error) -> Void)

extension URLSession: NetworkEngine {
    func executeRequest(for model: RequestModel, completionHandler: @escaping Handler) {
        let request = model.createRequest()
        let task = dataTask(with: request.createRequest(), completionHandler: completionHandler)
        task.resume()
    }
}

class NetworkManager {

    // MARK: - Properties
    static private var _instance: NetworkManager!
    static var instance: NetworkManager {
        return _instance
    }
    private let engine: NetworkEngine
    
    
    // MARK: - Initializers
    init(engine: NetworkEngine = URLSession.shared) {
        self.engine = engine
    }
    
    class func initStack(engine: NetworkEngine = URLSession.shared) {
        _instance = NetworkManager(engine: engine)
    }
    
    // MARK: - Public
    func execute<S: ResponseModel>(requestModel: RequestModel, completion: @escaping (_ responseModel: S?)->Void, failure: FailureResponseBlock? = nil) {
        
        engine.executeRequest(for: requestModel) { (data, response, error) in
            
            if let error = error {
                failure?(error)
                return
            }
            
            if let validationError = self.verifyResponse(response: response, data: data, defaultText: NSLocalizedString("UnknownError", comment: "")) {
                failure?(validationError)
            }
            
            
            let responseModel = self.handle(data: data, type: S.self)
            completion(responseModel)
        }
    }
    
    // MARK: - Utility
    fileprivate  func verifyResponse(response: URLResponse?, data: Data?, defaultText: String) -> NSError? {
        
        guard let http = response as? HTTPURLResponse else {
            return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey:defaultText])
        }
        
        if http.statusCode < 200 || http.statusCode >= 400 {
            var info = [String:Any]()
            if let d = data {
                let json =  try? JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: String]
                if let message = json??["message"] {
                    info[NSLocalizedDescriptionKey] = message
                }
            }
            let error: NSError = NSError(domain: "", code: http.statusCode, userInfo: info)
            return error
        }
        return nil
    }
    
    fileprivate func handle<R: ResponseModel>(data: Data?, type: R.Type) -> R?{
        guard let responseData = data else {
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let responseModel = try decoder.decode(type, from: responseData)
            return responseModel
        } catch let err as NSError {
            print(err.localizedDescription)
            return nil
        }
    }
}
