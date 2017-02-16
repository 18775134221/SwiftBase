//
//  PoperMenuMD.swift
//  SwiftTest
//
//  Created by MAC on 2017/2/15.
//  Copyright © 2017年 MAC. All rights reserved.
//

import UIKit
import Foundation

class PoperMenuMD: NSObject {
    
    var imageName: String?
    var itemName: String?
    
    // MARK:- 自定义构造函数
    init(dict : [String : NSObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
