//
//  UITextView-Extension.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/15.
//  Copyright © 2016年 MAC. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
    /*
     * 便利构造器 
     * frame 
     * placeHolderText 提示语
     * placeColor 提示语的颜色
     * fontSize 提示语的字体大小
     */
    convenience init(frame: CGRect, placeHolderText: String? = "", placeColor: UIColor? = UIColor.lightGray, fontSize: CGFloat? = 15.0) {
        let textView = UITextView().then {
            $0.frame = frame
        }
        let _ = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: fontSize!)
            $0.text = placeHolderText
            $0.numberOfLines = 0
            $0.sizeToFit()
            $0.textColor = placeColor
            textView.addSubview($0)
            textView.setValue($0, forKey: "_placeholderLabel")
        }

        self.init(frame:frame)
    }
}


