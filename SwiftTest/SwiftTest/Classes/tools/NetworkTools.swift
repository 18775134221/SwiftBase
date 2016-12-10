//
//  NetworkTools.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit


class NetworkTools: NSObject {
    
    fileprivate let baseServiceUrl: String = "www.baidu.com"
    // 请求类型
    enum requestType {
        case get, post
    }
    
    // 请求网络数据
    class func requestData(type: requestType, params: [String:String]? = nil, finishCallback: (_ result: Any) ->()) {
        
        // 1.获取类型
//        var methodType = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
    }

}
