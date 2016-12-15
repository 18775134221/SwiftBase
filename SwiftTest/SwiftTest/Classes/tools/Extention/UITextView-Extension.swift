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
        let textView = UITextView()
        textView.frame = frame
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize!)
        label.text = placeHolderText
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = placeColor
        
        textView.addSubview(label)
        textView.setValue(label, forKey: "_placeholderLabel")
        self.init(frame:frame)
    }
}


