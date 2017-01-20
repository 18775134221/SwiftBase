//
//  UserConfig.swift
//  SwiftTest
//
//  Created by MAC on 2017/1/20.
//  Copyright © 2017年 MAC. All rights reserved.
//

import Foundation

struct UserConfig: BoolDefaultSettable {
    enum BoolKey: String {
        case isEve
    }
}

// MARK: - 基本的使用方法
extension ShoppingCartVC {
    func test() {
        UserConfig.set(true, forKey: .isEve)
        debugLog(UserConfig.bool(forKey: .isEve))
    }
}
