//
//  FMDBDatabaseTool.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/31.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import FMDB

class FMDBDatabaseTool: NSObject {
    // 创建单例
    static var sharedInstance : FMDBDatabaseTool {
        struct Static {
            static let instance : FMDBDatabaseTool = FMDBDatabaseTool()
        }
        return Static.instance
    }
    
    
    var dbQueue: FMDatabaseQueue!
    
    /**
     *  打开数据库
     */
    func openDB(DBName: String)
    {
        // 1.根据传入的数据库名称拼接数据库路径
        let path = DBName.docDir()
        print(path)
        
        // 2.创建数据库对象
        // 注意: 如果是使用FMDatabaseQueue创建数据库对象, 那么就不用打开数据库
        dbQueue = FMDatabaseQueue(path: path)
        
        
        // 4.创建表
        creatTable()
    }
    
    private func creatTable()
    {
        // 1.编写SQL语句
        let sql = "CREATE TABLE IF NOT EXISTS T_Person( \n" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT, \n" +
            "name TEXT, \n" +
            "age INTEGER \n" +
        "); \n"
        
        // 2.执行SQL语句
        dbQueue!.inDatabase { (db) -> Void in
            db?.executeUpdate(sql, withArgumentsIn: nil)
        }
    }
    
    func insertData() {
        // 1.定义SQL语句
        let sql = "INSERT OR REPLACE INTO T_Status" +
            "(statusId, statusText, userId)" +
            "VALUES" +
        "(?, ?, ?);"
        
        
        // 2.执行SQL语句（用事务）（更新 删除 用 inDatabase）
        FMDBDatabaseTool.sharedInstance.dbQueue?.inTransaction({ (db, rollback) -> Void in
            let statuses: [Dictionary<String, Any>] = [Dictionary<String, Any>]()
            for dict in statuses
            {
                let statusId = dict["id"]!
                // JSON -> 二进制 -> 字符串
                let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
                let statusText = String(data: data, encoding: String.Encoding.utf8)!
                print(statusText)
                // executeUpdate(sql, statusId, statusText, "userId")
                // BOOL success = [db executeUpdate:@"INSERT INTO authors (identifier, name, date, comment) VALUES (?, ?, ?, ?)", @(identifier), name, date, comment ?: [NSNull null]];
                if !((db?.executeUpdate(sql, withArgumentsIn: nil))!)
                {
                    // 如果插入数据失败, 就回滚
                    // MARK: 不知道是什么问题回滚不能设置
                    //rollback?.memory = true
                }
                
                // 关闭数据库
                FMDBDatabaseTool.sharedInstance.dbQueue.close()
                
            }
        })
    }
    
}
