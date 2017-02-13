//
//  UserDefault-Extension.swift
//  SwiftTest
//
//  Created by MAC on 2017/2/13.
//  Copyright © 2017年 MAC. All rights reserved.
//

import Foundation
import UIKit


protocol UserDefaultNameSpace {}

extension UserDefaultNameSpace {
    static func namespace<T>(_ key:T) -> String where T: RawRepresentable {
        return "\(Self.self).\(key.rawValue)"
    }
}

protocol UserDefaultSettable: UserDefaultNameSpace {
    associatedtype UserDafaultKey: RawRepresentable
}

extension UserDefaultSettable where UserDafaultKey.RawValue == String {}

extension UserDefaultSettable {
    /// 关于 Int 类型的存储和读取
    static func set(value: Int, forKey key: UserDafaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(value, forKey: key)
        
    }
    
    static func integer(value: Int, forKey key: UserDafaultKey) {
        let key = namespace(key)
        UserDefaults.standard.integer(forKey: key)
    }
    
    /// 关于 String 类型存储和读取
    static func set(value: Any?, forKey key: UserDafaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func string(value: Any?, forKey key: UserDafaultKey) {
        let key = namespace(key)
        UserDefaults.standard.string(forKey: key)
    }
}

// MARK: - 使用方式
extension UserDefaults {
    struct Account: UserDefaultSettable {
        enum  UserDafaultKey: String {
            case name
            case age
            case birth
        }
    }
}

class test {
    func testFunction() {
        UserDefaults.Account.set(value: 20, forKey: .age)
        UserDefaults.Account.set(value: "hjq", forKey: .name)
    }

}

