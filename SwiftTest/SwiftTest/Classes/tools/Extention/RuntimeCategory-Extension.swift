//
//  RuntimeCategory-Extension.swift
//  SwiftTest
//
//  Created by MAC on 2017/1/3.
//  Copyright © 2017年 MAC. All rights reserved.
//

import Foundation
import ObjectiveC
import UIKit

extension UIView {
    
    // 改进写法【推荐】
    
    struct RuntimeKey {
        static let jkKey = UnsafeRawPointer.init(bitPattern: "JKKey".hashValue)
        /// ...其他Key声明
    }
    
    var jkPro: String? {
        set {
            objc_setAssociatedObject(self, RuntimeKey.jkKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, RuntimeKey.jkKey) as? String
        }
    }
}
