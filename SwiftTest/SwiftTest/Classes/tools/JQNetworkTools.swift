//
//  JQNetworkTools.swift
//  SwiftTest
//
//  Created by MAC on 2017/2/9.
//  Copyright © 2017年 MAC. All rights reserved.
//

import UIKit
import Alamofire


class JQNetworkTools {
    // 服务器地址
    fileprivate let baseServiceUrl: String = "http://192.168.1.250:4000/mockjsdata/6"
    
    fileprivate var manger:SessionManager! = {
        //配置 , 通常默认即可
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        
        //设置超时时间为15S
        config.timeoutIntervalForRequest = 30
        //根据config创建manager
        let tempManger = SessionManager(configuration: config)
        
        return tempManger
    }()
    
    fileprivate var upLoadManger:SessionManager! = {
        //配置 , 通常默认即可
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        //设置超时时间为60S
        config.timeoutIntervalForRequest = 60
        //根据config创建manager
        let tempManger = SessionManager(configuration: config)
        return tempManger
    }()
    
    
    // 请求类型
    public enum requestType {
        case get, post
    }
    
    // 创建单例
    static var sharedInstance : JQNetworkTools {
        struct Static {
            static let instance : JQNetworkTools = JQNetworkTools()
        }
        return Static.instance
    }
    
    
    // MARK: - 请求的网络数据请求
    public func requestData(methodName: String? = "/", type: requestType, params: [String:Any]? = nil, finishCallback: @escaping (_ result: Any) ->()) {
        
        // 1.获取类型
        let methodType = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.自定义头部
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "X-Requested-With": "GFBiOS",
            "f": "2",
            "appv": "3.5"
        ]
        
        // 3.发起网络请求
        let tempBaseUrlStr = baseServiceUrl.appending(methodName!)
        manger.request(tempBaseUrlStr, method: methodType, parameters: params, encoding: JSONEncoding.default,headers: headers)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                // 4.获取结果
                guard let result = response.result.value else {
                    print(response.result.error as Any)
                    return
                }
                // 5.将结果回调出去
                finishCallback(result)
        }
    
    }
    
    // MARK: - 文件上传
    public func upLoadFileData(methodName: String? = "/", params: [String:Any]? = nil, finishCallback: @escaping (_ result: Any) ->()) {
        let postUrlStr = baseServiceUrl.appending(methodName!)
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "X-Requested-With": "GFBiOS",
            "f": "2",
            "appv": "3.5"
        ]
        
        upLoadManger.upload( multipartFormData: { multipartFormData in
            // 图片数据绑定
            for (key, value) in params! {
                if (value as AnyObject).isKind(of: UIImage.self) {
                    let fileName = key + ".jpg"
                    multipartFormData.append(UIImageJPEGRepresentation(value as! UIImage, 0.5)!, withName: key, fileName: fileName, mimeType: "image/jpeg")
                }else {
                    assert(value is String)
                    let utf8Value = (value as AnyObject).data(using: String.Encoding.utf8.rawValue)!
                    multipartFormData.append(utf8Value, withName: key)
                }
            }
        },
            to: postUrlStr,headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        
                        // 获取结果
                        guard let result = response.result.value else {
                            print(response.result.error as Any)
                            return
                        }
                        // 将结果回调出去
                        finishCallback(result)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }
}
