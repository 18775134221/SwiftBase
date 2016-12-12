//
//  NetworkTools.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import Alamofire


class NetworkTools: NSObject {
    
    fileprivate let baseServiceUrl: String = "www.baidu.com"
    // 请求类型
    enum requestType {
        case get, post
    }
    
    // 请求网络数据
    class func requestData(type: requestType, params: [String:Any]? = nil, finishCallback: @escaping (_ result: Any) ->()) {
        
        // 1.获取类型
        let methodType = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request("www.baidu.com", method: methodType, parameters: params, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                // 3.获取结果
                guard let result = response.result.value else {
                    print(response.result.error as Any)
                    return
                }
                
                // 4.将结果回调出去
                finishCallback(result)
        }
        
        
        
    }

}
