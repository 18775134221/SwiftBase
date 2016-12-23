# 搭建Swift项目的基本骨架

- 1.使用UITabBarController + 4NavigationViewControll的方式
- 2.自定义UITabBar ,按钮凸出的部分可以使用hitTest增加额外的点击事件
- 3.新增新闻查看器

# 一、161210 完成主框架的搭建

- 1.UITabBar的自定义 

enum plusLocation {

    case plusDefault
    case plusUp
}

class BaseTabBar: UITabBar {
    
    var type: plusLocation? = .plusDefault
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count: Int = (items?.count)! + 1
        let btnW: CGFloat = UIScreen.main.bounds.size.width / CGFloat(count)
        let btnH: CGFloat = 49.0;
        var i: Int = 0
        
        for (_,button) in self.subviews.enumerated() {
            if button.isKind(of: NSClassFromString("UITabBarButton")!) {
                if 2 == i {
                    i += 1
                }
                button.frame = CGRect(x: btnW * CGFloat(i), y: 0, width: btnW, height: btnH)
                i += 1
                
            
            }
            
            if type == .plusDefault {
                pBtn.center = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
            }else{
                pBtn.center = CGPoint(x: frame.size.width * 0.5, y: 0)
            }

        }
    }
    
    
    fileprivate lazy var pBtn: UIButton = {[weak self] in
        
        let btn: UIButton = UIButton(type:.custom)
        btn.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn.backgroundColor = UIColor.red
        btn.sizeToFit()
        self?.addSubview(btn)
        return btn
    }()
    
    // 重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if false == self.isHidden {
            let nPoint: CGPoint = convert(point, to: pBtn)
            if pBtn.point(inside: nPoint, with: event) {
                return pBtn
            }else{
               return super.hitTest(point, with: event)
            }
        }else{
            return super.hitTest(point, with: event)
        }
        
    }
    
    
}

# 二、161212 完成网络请求工具的封装

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
