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
    class func getFileSize(path: String,completionBlock:@escaping (_ totalSize: NSInteger) -> ()) {
        DispatchQueue.global().async { // 子线程中处理耗时操作
            var totalSize: NSInteger = 0
            let fileManager = FileManager.default
            var isDirectory: ObjCBool = ObjCBool(false)
            let isFileExist = fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
            guard isFileExist else { return }
            guard isDirectory.boolValue else {
                let floder = try! fileManager.attributesOfItem(atPath: path)
                for (_, bcd) in floder {
                    totalSize += (bcd as AnyObject).integerValue
                }
                // 回到主线程
                DispatchQueue.main.async {
                    completionBlock(totalSize)
                }
                return
            }
            
            let subPaths: [String] = fileManager.subpaths(atPath: path)!
            for subPath in subPaths {
                let filePath = NSURL(string: path)?.appendingPathComponent(subPath)
                var isDirectory: ObjCBool = ObjCBool(false)
                let isExistFile = fileManager.fileExists(atPath: "\(filePath)", isDirectory: &isDirectory)
                if isDirectory.boolValue == true && isExistFile == true && "\(filePath)".contains("DS") == false {
                    let floder = try! fileManager.attributesOfItem(atPath: "\(filePath)")
                    for (_, bcd) in floder {
                        totalSize += (bcd as AnyObject).integerValue
                    }
                }
            }
            // 回到主线程
            DispatchQueue.main.async {
                completionBlock(totalSize)
            }
        }
    }
    
    func getFileSize(path: String,completionBlock:@escaping (_ totalSize: NSInteger) -> ()) {
        NSObject.getFileSize(path: path, completionBlock: completionBlock)
    }
    
    // MARK: - 获取缓存的目录
    class func cachesPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!

    }
    
    func cachesPath() -> String {
        return NSObject.cachesPath()
    }
    
    // MARK: - 清空文件
    class func removeCaches(completionBlock: @escaping () -> ()) {
        OperationQueue().addOperation { 
            let fileManager = FileManager.default
            let path = cachesPath()
            var isDirectory: ObjCBool = ObjCBool(false)
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
                try! fileManager.removeItem(at: filePath!)
                
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
