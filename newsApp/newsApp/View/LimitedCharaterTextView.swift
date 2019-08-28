//
//  LimitedCharaterTextView.swift
//  TextViewExt
//
//  Created by Ruslan Latfulin on 8/28/19.
//  Copyright © 2019 Ruslan Latfulin. All rights reserved.
//

import Foundation
import UIKit

class LimitedCharaterTextView: UITextView {

    var limitedText: String? {
        didSet {
            update()
        }
    }

    var characterLimit: Int = 100 {
        didSet {
            update()
        }
    }

    private let seeMoreString: NSMutableAttributedString = {
        let seeMoreString = NSMutableAttributedString(string: " Show More")
        let range = NSRange(location: 0, length: seeMoreString.length)
        seeMoreString.addAttribute(NSAttributedString.Key.font,
                                   value: UIFont(name: "Helvetica", size: 12)!,
                                   range: range)
        seeMoreString.addAttribute(NSAttributedString.Key.link,
                                   value: "seeMore",
                                   range: range)

        return seeMoreString
    }()

    private let textFont = UIFont(name: "Helvetica", size: 12)!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        limitedText = "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip excelsior pendulum optum"
    }



    private func update() {
        attributedText = NSMutableAttributedString(string: "Henlo Frens")
        if let text = limitedText {
            let baseText = NSMutableAttributedString(string: "")
            let allowedText = text.prefix(characterLimit)
            let mutableTextString: NSMutableAttributedString
//
            if text.count > characterLimit {
                mutableTextString = NSMutableAttributedString(string: String(allowedText) + "...")
            } else {
                mutableTextString = NSMutableAttributedString(string: String(allowedText))
            }

            let range = NSRange(location: 0, length: mutableTextString.length)
            mutableTextString.addAttribute(NSAttributedString.Key.font,
                                           value: textFont,
                                           range: range)



            mutableTextString.addAttribute(NSAttributedString.Key.foregroundColor,
                                           value: UIColor.black,
                                           range: range)

            attributedText = mutableTextString

            baseText.append(mutableTextString)
            if baseText.length > characterLimit {
                baseText.append(seeMoreString)
            }

            linkTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.blue,
                NSAttributedString.Key.font: textFont
            ]
            attributedText = baseText

        }
    }

    private func setup() {
        delegate = self
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
        isEditable = false
        isSelectable = true
    }
}

extension LimitedCharaterTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        attributedText = NSAttributedString(string: limitedText!)
        print("link pressed")
        return false
    }
}
