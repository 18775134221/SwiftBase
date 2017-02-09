//
//  NetworkTools.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import Alamofire
import RxCocoa
import RxSwift


// MARK: - 基于RxSwift 封装网络请求
let BaseUrl = "http://timelessg.cn/"

enum CZSError: Swift.Error {
    case httpFailed
    case mapperError
    case customError(msg: String, code: Int)
    
    func show() -> CZSError {
        switch self {
        case .httpFailed: break
        case .mapperError: break
        case .customError(msg: _, code: _): break

        }
        return self
    }
}

let SUCCESSCODE    = 1
let RESULT_CODE    = "code"
let RESULT_MESSAGE = "msg"
let RESULT_DATA    = "result"

// Mark: - 面向协议编程
public protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var hud: Bool { get }
}

extension Request {
    var hud: Bool {
        return false
    }
    
    var method: HTTPMethod {
        return HTTPMethod.post
    }
}

protocol RequestClient {
    var host: String { get }
    func send<T: Request>(_ r: T) -> Observable<[String: Any]>
}

public struct NetworkClient: RequestClient {
    var host: String {
        return BaseUrl
    }
    
    func send<T : Request>(_ r: T) -> Observable<[String : Any]> {
        if r.hud {
            
        }


        return Observable<[String: Any]>.create({ (observer) -> Disposable in
            // 2.发送网络请求
            Alamofire.request(BaseUrl + r.path, method: r.method, parameters: r.parameters, encoding: JSONEncoding.default)
                .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    print("Progress: \(progress.fractionCompleted)")
                }
                .validate { request, response, data in
                    return .success
                }
                .responseJSON { response in
                    debugPrint(response)
                    switch response.result {
                    case .success(_):
                        if let json = response.result.value as? [String: Any] {
                            if let code = json[RESULT_CODE] as? Int {
                                if code == SUCCESSCODE {
                                    observer.onNext(json[RESULT_DATA] as! [String: Any])
                                    observer.onCompleted()
                                }else {
                                    let message = json[RESULT_MESSAGE] as! String
                                    observer.onError(CZSError.customError(msg: message, code: code).show())
                                }
                            }else {
                                observer.onError(CZSError.mapperError.show())
                            }
                        }else {
                            observer.onError(CZSError.mapperError.show())
                        }
                    case .failure(_):
                        observer.onError(CZSError.httpFailed.show())
                    }
            }
            return Disposables.create {
                
            }
        })
    }


}



// MARK: - 网络请求基本封装
// 基本的服务器地址
let baseServiceUrl: String = "http://192.168.1.250:4000/mockjsdata/6/cate/picList"
// 测试的服务器地址
let baseTestServiceUrl: String = "www.baidu.com"

class NetworkTools: NSObject {
    
    // 请求类型
    enum requestType {
        case get, post
    }
    // 请求网络数据
    class func requestData(type: requestType, params: [String:Any]? = nil, finishCallback: @escaping (_ result: Any) ->()) {
        
        // 1.获取类型
        let methodType = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5     // 秒
        
        /* 设置超时时间
        //设置manager属性 (重要)
        var manger:SessionManager? = nil
        
        //配置 , 通常默认即可
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        
        //设置超时时间为15S
        config.timeoutIntervalForRequest = 15
        //根据config创建manager
        manger = SessionManager(configuration: config)
        //这里和上述大致相同
        manger?.request("https://www.baidu.com", method: .get).response { (response) in
            
            print("-----------------\(response)")
        }
        */
        
        // 自定义头部
        let headers: HTTPHeaders = [
            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "application/json"
        ]
        Alamofire.request(baseServiceUrl, method: methodType, parameters: params, encoding: JSONEncoding.default,headers: headers)
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

/* 自定义HTTP header
let headers: HTTPHeaders = [
    "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
    "Accept": "application/json"
]

Alamofire.request("https://httpbin.org/headers", headers: headers).responseJSON { response in
    debugPrint(response)
}
 */

/* 二进制上传文件1
 Alamofire.upload(
 multipartFormData: { multipartFormData in
    multipartFormData.append(unicornImageURL, withName: "unicorn")
    multipartFormData.append(rainbowImageURL, withName: "rainbow")
 },
 to: "https://httpbin.org/post",
 encodingCompletion: { encodingResult in
 switch encodingResult {
 case .success(let upload, _, _):
 upload.responseJSON { response in
 debugPrint(response)
 }
 case .failure(let encodingError):
 print(encodingError)
 }
 }
 )
 */

/* 上传文件2
 let fileURL = Bundle.main.url(forResource: "video", withExtension: "mov")
 
 Alamofire.upload(fileURL, to: "https://httpbin.org/post")
 .uploadProgress { progress in // main queue by default
 print("Upload Progress: \(progress.fractionCompleted)")
 }
 .downloadProgress { progress in // main queue by default
 print("Download Progress: \(progress.fractionCompleted)")
 }
 .responseJSON { response in
 debugPrint(response)
 }
 */
