//
//  UserMD.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/31.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import Realm

class userMessageMD: RLMObject {
    dynamic var title: String?
    dynamic var messageID: String!
}

class UserMD: RLMObject {
    dynamic var userID: String!
    dynamic var name: String!
    
    // List 是个泛型
    //var userMessages = List<userMessageMD>()
    
    // MARK: - 设置主键
//    override static func primaryKey() -> Int? {
//        return "userID"
//    }
}

