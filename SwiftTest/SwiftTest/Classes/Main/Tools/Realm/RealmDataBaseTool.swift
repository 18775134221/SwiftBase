//
//  RealmDataBaseTool.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/31.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import Realm

class RealmDataBaseTool: NSObject {

    // MARK: - 初始化Rleam数据库
    func createDataBase() {
        let config = RLMRealmConfiguration.default()
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("HJQ").appendingPathExtension("Realm")
        var realm: RLMRealm?
        do {
           realm =  try RLMRealm.init(configuration: config)
        } catch  {
            debugLog(error)
        }
        debugLog(realm)
        
        
    }
}
