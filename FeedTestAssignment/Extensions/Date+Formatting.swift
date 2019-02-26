//
//  Date+Formatting.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/26/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

extension Date {

    static func appDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY'T'HH:mm:ss"
        return formatter
    }
    
    static func from(string: String) -> Date? {
    
        return appDateFormatter().date(from: string)
    }
    
    func convertToString() -> String {
        return Date.appDateFormatter().string(from: self)
    }
}
