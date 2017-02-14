//
//  NSObject-Extension.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/27.
//  Copyright © 2016年 MAC. All rights reserved.
//

import Foundation

/* 计算缓存  */
extension NSObject {
    /* 类方法：
     异步方法
     使用回调,block
     获取文件尺寸
     */
    class func getFileSizeWithFileName(path: String,completionBlock:@escaping (_ totalSize: UInt64) -> () ) {
        // 在子线程中计算文件大小
        DispatchQueue.global().async { () -> Void in
            debugLog(path)
            // 1.文件总大小
            var totalSize: UInt64 = 0;
            // 2.创建文件管理者
            let fileManager = FileManager.default
            // 3.判断文件存不存在以及是否是文件夹
            var isDirectory: ObjCBool = ObjCBool(false)
            let isFileExist = fileManager.fileExists(atPath: path , isDirectory: &isDirectory)
            
            if (!isFileExist) {return} // 文件不存在
            if (isDirectory).boolValue { // 是文件夹
                guard let subPaths = fileManager.subpaths(atPath: path) else { return }
                for subPath in subPaths {
                    let filePath = path.appendingFormat("/%@", subPath)
                    var isDirectory: ObjCBool = ObjCBool(false)
                    let isExistFile = fileManager.fileExists(atPath: filePath, isDirectory: &isDirectory)
                    if (!isDirectory.boolValue && isExistFile && !filePath.contains("DS")) {
                        if let attr: NSDictionary = try! fileManager.attributesOfItem(atPath: path) as NSDictionary? {
                            totalSize += attr.fileSize()
                        }
                    }
                }
            }else{ // 不是文件夹
                if let attr: NSDictionary = try! fileManager.attributesOfItem(atPath: path) as NSDictionary? {
                    totalSize += attr.fileSize()
                }
            }
            
            // 回到主线程,把计算的大小通过壁报传递出去
            DispatchQueue.main.async() { () -> Void in
                completionBlock(totalSize)
            }
        }
    }
    
    // 对象方法：根据缓存路径去计算缓存文件的大小，通过闭包返回缓存大小
    func getFileSizeWithFileName(path: String, completionBlock:@escaping (_ totalSize: UInt64) -> ()) {
        NSObject.getFileSizeWithFileName(path: path, completionBlock:completionBlock)
    }
}

/** 获取缓存路径 */
extension NSObject {
    class func cachesPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
    }
    
    func cachesPath() -> String {
        return NSObject.cachesPath()
    }
}

/** 清除缓存 */
extension NSObject {
    class func removeCachesWithCompletion(completionBlock: @escaping ()->()) {
        OperationQueue().addOperation { () -> Void in
            // 创建文件管理者
            let fileManager = FileManager.default
            
            // 删除文件
            let path = self.cachesPath() as String
            var isDirectory: ObjCBool = ObjCBool(false)
            let isFileExist = fileManager.fileExists(atPath: path , isDirectory: &isDirectory)
            
            if (!isFileExist)  { return } // 文件不存在
            if (isDirectory).boolValue {
                guard let enumerator = fileManager.enumerator(atPath: path) else { return }
                for subPath in enumerator {
                    let subPath = subPath as? String
                    let filePath = path.appendingFormat("/%@", subPath!)
                    // 移除文件Or文件夹
                    try? fileManager.removeItem(atPath: filePath)
                }
            }
            
            // 回到主线程
            OperationQueue.main.addOperation({ () -> Void in
                completionBlock()
            })
        }
    }
    
    func removeCachesWithCompletion(completionBlock: @escaping ()->()) {
        NSObject.removeCachesWithCompletion(completionBlock: completionBlock)
    }
}
