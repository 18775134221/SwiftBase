//
//  RealmDataBaseTool.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/31.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import RealmSwift

class RealmDataBaseTool: NSObject {

    // MARK: - 初始化Rleam数据库
    func createDataBase() {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("HJQ").appendingPathExtension("Realm")
        var realm: Realm?
        do {
           realm =  try Realm.init(configuration: config)
        } catch  {
            debugLog(error)
        }
        debugLog(realm)
    }
    
    
    
    // MARK: - 建表插入数据
    func insertData() {
        let realm = try! Realm()
        // 通过主键查找到对应的数据
        var userMD = realm.object(ofType: UserMD.self,forPrimaryKey: "")
        if userMD == nil {
            userMD = UserMD()
        }
        
        let messageID = "10000"
        try! realm.write {
            var userMessageMD: UserMessageMD? = nil
            let pred = NSPredicate(format: "messageID = \(messageID) ")
            let resultIndex = userMD!.userMessages.index(matching: pred)
            if resultIndex != NSNotFound { // 已经存在
                userMessageMD = userMD!.userMessages[resultIndex!]
            }else {
                userMessageMD = UserMessageMD()
                // 不存在则继续追加
                userMD?.userMessages.append(userMessageMD!)
            }
            
            realm.add(userMD!, update: true)
        }
        
        
    
    }
    
    // MARK: - 查询数据
    func queriesDatas() {
        let realm = try! Realm()
        
        // 通过主键查找到对应的数据
        let userMD = realm.object(ofType: UserMD.self,forPrimaryKey: "")
        
        debugLog(userMD)
    }
}
