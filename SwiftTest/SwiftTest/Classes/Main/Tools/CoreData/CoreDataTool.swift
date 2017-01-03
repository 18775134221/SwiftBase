//
//  CoreDataTool.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/31.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import CoreData

/* 使用方法
//打开
let zyCore = ZYCoreData.shareInstance();
zyCore.openCoreData( resource: "ZYCoreDataTest");
let arr = ["a","fd","ed"];
let data = NSKeyedArchiver.archivedData(withRootObject: arr);
//删除
zyCore.removeData(entyName: "Test", predStr: "id>0");
//插入
zyCore.insertData(entyName: "Test", dic: ["id":1,"height":Float(183.2),"name":"beier","sex":1,"addr":data]);
//修改
zyCore.changeData(entyName: "Test", predStr: "id=1", dic: ["id":1,"height":Float(183.2),"name":"beier","sex":1,"addr":data]);
//查询
let squArr = zyCore.squaryData(entyName: "Test", predStr: "id>0");

for object in squArr!! {
    let obj = object;
    //            let squResultdata = NSKeyedUnarchiver.unarchiveObject(with: obj.value(forKey: "addr") as! Data);
    print(obj.value(forKey: "name"));
}*/

class CoreDataTool: NSObject {
    
    // 创建单例
    static var sharedInstance : CoreDataTool {
        struct Static {
            static let instance : CoreDataTool = CoreDataTool()
        }
        return Static.instance
    }
    
    var _contenx : NSManagedObjectContext?
    
    /**打开数据库若数据库不存在，自动创建
     entyName表名,resource数据库名字
     */
    func openCoreData(resource: String) {
        //拿到资源文件
        let filePath = Bundle.main.url(forResource: resource, withExtension: "momd")
        
        if filePath == nil{
            
            return
        }
        //读取数据模型
        let model = NSManagedObjectModel.init(contentsOf: filePath!)!
        
        //根据model初始化数据助理
        let coordinator = NSPersistentStoreCoordinator.init(managedObjectModel: model)
        //将数据模型存储到沙盒路径下
        let path = NSHomeDirectory().appending("/Documents/ZYCoreData.db")
        //准尉url类型的路径
        let url = URL.init(fileURLWithPath: path)
        
        let store = try?coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: "", at: url, options: nil)
        if store == nil {
            //数据库存储异常
            print("数据存储异常")
        }
        
        _contenx = NSManagedObjectContext.init(concurrencyType:NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        _contenx?.persistentStoreCoordinator = coordinator
    }
    
    // MARK: - 添加数据
    func insertData(entyName: String,dic: NSDictionary) {
        
        let object = NSEntityDescription.insertNewObject(forEntityName: entyName, into: _contenx!)
        let keyArr = dic.allKeys
        for i in 0 ..< keyArr.count {
            
            let key = keyArr[i]
            let value = dic.object(forKey: key)
            object.setValue(value, forKey: key as! String)
        }
        _contenx?.insert(object)
    }
    
    // MARK: - 删除数据
    func removeData(entyName: String,predStr: String) {
        
        //构建查询请求 NSFetchRequestResult
        let request = NSFetchRequest<NSManagedObject>.init()
        //设置查询请求，查询模型
        request.entity = NSEntityDescription.entity(forEntityName: entyName, in: _contenx!);
        //设置查询条件
        let cate = NSPredicate.init(format: predStr);
        request.predicate = cate;
        //执行查询请求
        let objectArr = try?_contenx?.fetch(request);
        
        
        for object in objectArr!! {
            
            _contenx?.delete(object);
            
        }
        
    }
    
    // MARK: - 更新数据
    func changeData(entyName: String,predStr: String,dic: NSDictionary) {
        
        //构建查询请求 NSFetchRequestResult
        let request = NSFetchRequest<NSManagedObject>.init()
        //设置查询请求，查询模型
        request.entity = NSEntityDescription.entity(forEntityName: entyName, in: _contenx!)
        //设置查询条件
        let cate = NSPredicate.init(format:predStr)
        request.predicate = cate
        //执行查询请求
        let objectArr = try?_contenx?.fetch(request)
        
        
        for object in objectArr!! {
            
            let keyArr = dic.allKeys
            for i in 0 ..< keyArr.count {
                
                let key = keyArr[i]
                let value = dic.object(forKey: key)
                object.setValue(value, forKey: key as! String)
            }
        }
    }
    
    // MARK: - 查找数据
    func squaryData(entyName: String,predStr: String) -> [NSManagedObject]??{
        
        //构建查询请求 NSFetchRequestResult
        let request = NSFetchRequest<NSManagedObject>.init()
        //设置查询请求，查询模型
        request.entity = NSEntityDescription.entity(forEntityName: entyName, in: _contenx!)
        //设置查询条件
        let cate = NSPredicate.init(format:predStr)
        request.predicate = cate;
        //执行查询请求
        let objectArr = try?_contenx?.fetch(request)
        
        return objectArr
    }
    
    
    
}
