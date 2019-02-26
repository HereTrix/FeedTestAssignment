//
//  UIManager.swift
//  PostTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

class UIManager {

    class func showStartScreen() {
        if CurrentUser.isLoggedIn {
            let vc = mainFlow()
            swapRootController(to: vc)
        } else {
            let vc = authFlow()
            swapRootController(to: vc)
        }
    }
    
    // MARK: - Generator
    class func authFlow() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        
        let authVC = storyboard.instantiateInitialViewController()!
        
        return authVC
    }
    
    class func mainFlow() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateInitialViewController()!
        
        return mainVC
    }
    
    // MARK: - Transitions
    class func swapRootController(to viewController: UIViewController, animated: Bool = false) {
        guard let window = UIApplication.shared.delegate?.window else {
            return
        }
        
        if animated {
            let transition = CATransition()
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            window?.layer.add(transition, forKey: kCATransition)
        }
        window?.rootViewController = viewController
    }
    
    // Not needed to create instance
    private init() {
        
    }
}
