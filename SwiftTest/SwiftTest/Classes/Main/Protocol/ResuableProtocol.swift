//
//  ResuableProtocol.swift
//  SwiftTest
//
//  Created by MAC on 2017/1/20.
//  Copyright © 2017年 MAC. All rights reserved.
//

import UIKit

protocol ViewNameReusable:class { }

extension ViewNameReusable where Self:UIView {
    static var reuseIdentifier:String {
        return String(describing: self)
    }
}
