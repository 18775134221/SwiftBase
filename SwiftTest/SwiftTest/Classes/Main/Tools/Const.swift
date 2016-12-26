//
//  Const.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/26.
//  Copyright © 2016年 MAC. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 自定义Log打印
func debugLog<T>(_ messsage : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\(fileName):(\(lineNum))-\(messsage)")
    #endif
}

// MARK: - API接口地址
struct URLAPI {
    static let HomeAPI = ""
}


// MARK: - API接口地址
struct Screen {
    static let ScreenW = UIScreen.main.bounds.size.width
    static let ScreenH = UIScreen.main.bounds.size.height
}
