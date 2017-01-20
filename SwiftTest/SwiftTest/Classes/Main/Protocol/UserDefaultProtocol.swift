//
//  UserDefaultProtocol.swift
//  SwiftTest
//
//  Created by MAC on 2017/1/20.
//  Copyright © 2017年 MAC. All rights reserved.
//

import Foundation

// MARK: - 生成命名空间
protocol KeyNameSpaceable {
    static func namespaced<T: RawRepresentable>(_ key: T) -> String
}

extension KeyNameSpaceable {
    static func namespaced<T: RawRepresentable>(_ key: T) -> String {
        debugLog(String(describing: self) + ".\(key.rawValue)")
        return String(describing: self) + ".\(key.rawValue)"
    }
}

protocol BoolDefaultSettable: KeyNameSpaceable {
    associatedtype BoolKey: RawRepresentable
}

extension BoolDefaultSettable where BoolKey.RawValue == String {
    static func set(_ value: Bool, forKey key: BoolKey) {
        UserDefaults.standard.set(value, forKey: namespaced(key))
    }
    
    static func bool(forKey key: BoolKey) -> Bool {
        return UserDefaults.standard.bool(forKey: namespaced(key))
    }
}
