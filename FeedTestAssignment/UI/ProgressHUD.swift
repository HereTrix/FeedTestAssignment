//
//  ProgressHUD.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/26/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

class ProgressHUD: UIView {
    
    private static var shared = ProgressHUD()
    private let indicatorView = UIImageView()
    private let progressLabel = UILabel()
    
    var spinnerSize = CGSize(width: 100, height: 100)
    static var defaultBackgroundColor = UIColor.clear
    
    private init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configuration
    private func configure() {
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        
        indicatorView.image = UIImage(named: "spinner")
        
        // Indicator
        addSubview(indicatorView)
        
        var constraint = NSLayoutConstraint(item: indicatorView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: spinnerSize.width)
        indicatorView.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: indicatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: spinnerSize.height)
        indicatorView.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        addConstraint(constraint)
        
        // Progress
        addSubview(progressLabel)
        progressLabel.textColor = UIColor.black
        progressLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        constraint = NSLayoutConstraint(item: progressLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: progressLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        addConstraint(constraint)
    }
    
    private func updateLayout() {
        
        guard let superview = superview else {
            return
        }
        
        var constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0)
        superview.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: 0)
        superview.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: 0)
        superview.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0)
        superview.addConstraint(constraint)
        
        layoutIfNeeded()
    }
    
    // MARK: - Animation
    private func startAnimation() {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Float.pi * 2
        animation.duration = 0.8
        animation.repeatCount = Float.greatestFiniteMagnitude
        
        indicatorView.layer.add(animation, forKey: "rotationAnimation")
    }
    
    private func stopAnimation() {
        DispatchQueue.main.async {
            self.indicatorView.layer.removeAllAnimations()
        }
    }
    
    
    // MARK: - Public
    class func show() {
        guard let window = UIApplication.shared.delegate?.window else {
            return
        }
        
        shared.frame = window!.bounds
        window?.addSubview(shared)
        window?.bringSubviewToFront(shared)
        
        shared.updateLayout()
        shared.startAnimation()
    }
    
    class func setProgress(_ progress: Float) {
        DispatchQueue.main.sync {
            guard let window = UIApplication.shared.delegate?.window else {
                return
            }
            
            if !(window?.subviews.contains(shared) ?? false) {
                show()
            }
            
            shared.progressLabel.text = String(format: "%.f%%", progress * 100)
        }
    }
    
    class func show(withStatus status: String) {
        show()
    }
    
    class func dismiss() {
        DispatchQueue.main.async {
            shared.progressLabel.text = nil
            shared.stopAnimation()
            shared.removeFromSuperview()
            shared.backgroundColor = defaultBackgroundColor
        }
    }
    
    // MARK: - Appearence
    class func setBackgroundColor(_ color: UIColor) {
        shared.backgroundColor = color
    }
}
