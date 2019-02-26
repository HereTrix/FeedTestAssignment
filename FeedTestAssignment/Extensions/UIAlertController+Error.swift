//
//  UIAlertController+Error.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

extension UIAlertController {

    class func show(error: String, from vc: UIViewController?) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
            alert.addAction(action)
            
            vc?.present(alert, animated: true, completion: nil)
        }
    }
}
