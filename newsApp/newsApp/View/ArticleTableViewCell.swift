//
//  ArticleTableViewCell.swift
//  newsApp
//
//  Created by Ruslan Latfulin on 8/28/19.
//  Copyright © 2019 Ruslan Latfulin. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: LimitedCharaterTextView!
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.origin.y += 10
            frame.origin.x += 10
            frame.size.height -= 15
            frame.size.width -= 2 * 10
            super.frame = frame
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2

        layer.shadowOpacity = 1
        layer.masksToBounds = false;
        clipsToBounds = false;
    }
}

