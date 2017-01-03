//
//  NSObject-Extension.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/27.
//  Copyright © 2016年 MAC. All rights reserved.
//

import Foundation

extension NSObject {
    
    // MARK: - 获取文件的Size
    class func getFileSize(path: String,completionBlock:@escaping (_ totalSize: UInt64) -> ()) {
        DispatchQueue.global().async { // 子线程中处理耗时操作
            debugLog(path)
            var totalSize: UInt64 = 0
            let fileManager = FileManager.default
            var isDirectory: ObjCBool = false
            let isFileExist = fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
            guard isFileExist else { return }
            guard isDirectory.boolValue else {
                let attr = try! fileManager.attributesOfItem(atPath: path)
                let fileSize: UInt64 = attr[FileAttributeKey.size] as! UInt64
                totalSize += fileSize
                // 回到主线程
                DispatchQueue.main.async {
                    completionBlock(totalSize)
                }
                return
            }
            
            let subPaths: [String] = fileManager.subpaths(atPath: path)!
            debugLog(subPaths)
            for subPath in subPaths {
                
                let filePath = NSURL(string: path)!.appendingPathComponent(subPath)!
                var isDirectory: ObjCBool = false
                //debugLog("\(filePath)")
                let isExistFile = fileManager.fileExists(atPath: "\(filePath)", isDirectory: &isDirectory)
                let flag = isDirectory.boolValue == true && isExistFile == true
                if  flag {
                    let attr = try! fileManager.attributesOfItem(atPath:"\(filePath)")
                    let fileSize: UInt64 = attr[FileAttributeKey.size] as! UInt64
                    totalSize += fileSize
                    
                }
            }
            // 回到主线程
            DispatchQueue.main.async {
                completionBlock(totalSize)
            }
        }
    }
    
    func getFileSize(path: String,completionBlock:@escaping (_ totalSize: UInt64) -> ()) {
        NSObject.getFileSize(path: path, completionBlock: completionBlock)
    }
    
    // MARK: - 获取缓存的目录
    class func cachesPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!

    }
    
    func cachesPath() -> String {
        return NSObject.cachesPath()
    }
    
    // MARK: - 清空文件
    class func removeCaches(completionBlock: @escaping () -> ()) {
        OperationQueue().addOperation { 
            let fileManager = FileManager.default
            let path = cachesPath()
            var isDirectory: ObjCBool = false
            let isFileExist = fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
            guard isFileExist else { return }
            guard isDirectory.boolValue else {
                // 回到主线程
                OperationQueue.main.addOperation({
                    completionBlock()
                })
                return
            }
            // 迭代器
            let enumerator = fileManager.enumerator(atPath: path)
            for subPath in enumerator! {
                let filePath = NSURL(string: path)?.appendingPathComponent(subPath as! String)
                // 移除文件或者文件夹
                try? fileManager.removeItem(at: filePath!)
                
            }
            // 回到主线程
            OperationQueue.main.addOperation({
                completionBlock()
            })
        }
    }
    
    func removeCaches(completionBlock: @escaping () -> ()) {
        NSObject.removeCaches {
            completionBlock()
        }
    }
}
