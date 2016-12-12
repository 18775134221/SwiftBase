# SwiftBase
简介
搭建Swift项目的基本骨架
1.使用UITabBarController + 4NavigationViewControll的方式
2.自定义UITabBar ,按钮凸出的部分可以使用hitTest增加额外的点击事件
3.新增新闻查看器

使用方法：仔细阅读代码就是可以使用

161210 完成主框架的搭建

161212 完成网络请求工具的封装


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
