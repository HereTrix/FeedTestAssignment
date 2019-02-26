//
//  FeedCollectionViewCell.swift
//  FeedTestAssignment
//
//  Created by HereTrix on 2/25/19.
//  Copyright © 2019 CHISoftware. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userNameBtn: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Cache calculation
    class func calculatedHeight(for text: String) -> Float {
        let staticHeight: CGFloat = 85
        let staticMargins: CGFloat = 30
        
        let expectedWidth = UIScreen.main.bounds.width - staticMargins
        let expectedFont = UIFont.systemFont(ofSize: 14)
        
        let calculatedHeight = text.height(withConstrainedWidth: expectedWidth, font: expectedFont) + staticHeight
        return Float(calculatedHeight)
    }
    
    // MARK: - Setup
    func setup(with feed: Post) {
        
        let userName = feed.user?.name ?? "Unknown"
        userNameBtn.setTitle(userName, for: .normal)
        contentTextView.text = feed.content
        dateLabel.text = feed.publishedAt?.convertToString()
    }
}
