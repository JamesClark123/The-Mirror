//
//  UILabelExtension.swift
//  The Mirror
//
//  Created by BC Swift Student Loan 1 on 12/2/18.
//  Copyright © 2018 BC Swift Student Loan 1. All rights reserved.
//

import UIKit

@IBDesignable
class KerningLabel: UILabel {
    
    @IBInspectable var kerning: CGFloat = 0.0 {
        didSet {
            if attributedText?.length == nil { return }
            
            let attrStr = NSMutableAttributedString(attributedString: attributedText!)
            let range = NSMakeRange(0, attributedText!.length)
            attrStr.addAttributes([NSAttributedString.Key.kern: kerning], range: range)
            attributedText = attrStr
        }
    }
}
