//
//  UserMD.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/31.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import RealmSwift

class UserMessageMD: Object {
    dynamic var title: String?
    dynamic var messageID: String!
}

class UserMD: Object {
    dynamic var userID: String!
    dynamic var name: String!
    
    // List 是个泛型
    var userMessages = List<UserMessageMD>()
    
    // MARK: - 设置主键
    override static func primaryKey() -> String? {
        return "userID"
    }

}

