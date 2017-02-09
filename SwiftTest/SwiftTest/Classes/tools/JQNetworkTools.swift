//
//  JQNetworkTools.swift
//  SwiftTest
//
//  Created by MAC on 2017/2/9.
//  Copyright © 2017年 MAC. All rights reserved.
//

import UIKit
import Alamofire

//定义一个结构体，存储认证相关信息
struct IdentityAndTrust {
    var identityRef: SecIdentity
    var trust: SecTrust
    var certArray: AnyObject
}

class JQNetworkTools {
    
    // 请求类型
    public enum requestType {
        case get, post
    }

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
        
        manger.delegate.sessionDidReceiveChallenge = { session, challenge in
            //认证服务器证书
            if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodServerTrust {
                print("服务端证书认证！")
                let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
                let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)!
                let remoteCertificateData
                    = CFBridgingRetain(SecCertificateCopyData(certificate))!
                let cerPath = Bundle.main.path(forResource: "tomcat", ofType: "cer")!
                let cerUrl = URL(fileURLWithPath:cerPath)
                let localCertificateData = try! Data(contentsOf: cerUrl)
                
                if (remoteCertificateData.isEqual(localCertificateData) == true) {
                    
                    let credential = URLCredential(trust: serverTrust)
                    challenge.sender?.use(credential, for: challenge)
                    return (URLSession.AuthChallengeDisposition.useCredential,
                            URLCredential(trust: challenge.protectionSpace.serverTrust!))
                    
                } else {
                    return (.cancelAuthenticationChallenge, nil)
                }
            }
                //认证客户端证书
            else if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodClientCertificate {
                print("客户端证书认证！")
                //获取客户端证书相关信息
                let identityAndTrust: IdentityAndTrust! = self.extractIdentity()
                
                let urlCredential:URLCredential = URLCredential(
                    identity: identityAndTrust.identityRef,
                    certificates: identityAndTrust.certArray as? [AnyObject],
                    persistence: URLCredential.Persistence.forSession);
                
                return (.useCredential, urlCredential);
            }
                // 其它情况（不接受认证）
            else {
                print("其它情况（不接受认证）")
                return (.cancelAuthenticationChallenge, nil)
            }
        }

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
        },to: postUrlStr,headers: headers,encodingCompletion: { encodingResult in
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
        })
    }
    
    //获取客户端证书相关信息
     func extractIdentity() -> IdentityAndTrust {
        var identityAndTrust: IdentityAndTrust!
        var securityError:OSStatus = errSecSuccess
        
        let path: String = Bundle.main.path(forResource: "mykey", ofType: "p12")!
        let PKCS12Data = NSData(contentsOfFile:path)!
        let key : NSString = kSecImportExportPassphrase as NSString
        let options : NSDictionary = [key : "123456"] //客户端证书密码
        //create variable for holding security information
        //var privateKeyRef: SecKeyRef? = nil
        
        var items : CFArray?
        
        securityError = SecPKCS12Import(PKCS12Data, options, &items)
        
        if securityError == errSecSuccess {
            let certItems:CFArray = items as CFArray!;
            let certItemsArray:Array = certItems as Array
            let dict:AnyObject? = certItemsArray.first;
            if let certEntry:Dictionary = dict as? Dictionary<String, AnyObject> {
                // grab the identity
                let identityPointer:AnyObject? = certEntry["identity"];
                let secIdentityRef:SecIdentity = identityPointer as! SecIdentity!
                print("\(identityPointer)  :::: \(secIdentityRef)")
                // grab the trust
                let trustPointer:AnyObject? = certEntry["trust"]
                let trustRef:SecTrust = trustPointer as! SecTrust
                print("\(trustPointer)  :::: \(trustRef)")
                // grab the cert
                let chainPointer:AnyObject? = certEntry["chain"]
                identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef,
                                                    trust: trustRef, certArray:  chainPointer!)
            }
        }
        return identityAndTrust;
    }
}



