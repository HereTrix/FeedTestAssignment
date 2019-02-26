//
//  ResponseModel.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

protocol ResponseModel: Decodable {
}

class ArrayResponse<T: ResponseModel>: ResponseModel {
    var array: [T]?
    
    init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let singleContainer = try? decoder.singleValueContainer()
        do {
            array = try singleContainer?.decode([T].self)
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
}
