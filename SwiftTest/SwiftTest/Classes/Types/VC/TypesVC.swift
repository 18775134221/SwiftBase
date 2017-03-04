//
//  TypesVC.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON

class TypesVC: BaseVC {

    let label_AnyO = UILabel().then { (label) in
        label.backgroundColor = .blue
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "Then库写法_2"
        label.frame = CGRect.init(x: 200, y: 260, width: 150, height: 40)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestData()
    }

    private func setupUI() {
        view.addSubview(label_AnyO)
    }
    
    private func requestData() {
        var dict: Dictionary<String,Any> = Dictionary<String,Any>()
        dict["id"] = "1"
        NetworkTools.requestData(type: .get, params: dict) { (result) in
            print(result);
            //let test = Mapper<TypeMD>().map(JSONString: result as! String)
            let test1 = Mapper<TypeMD>().map(JSONObject: result)
            //print(test?.data?.cate?.first?.name ??  "")
            print(test1?.data?.cate.first?.name ?? "")
        }
        
//        JQNetworkTools.sharedInstance.requestData(methodName: "/cate/picList", type: .get, params: nil, finishCallback: {(result) in
//            let test1 = Mapper<TypeMD>().map(JSONObject: result)
//            print(test1?.data?.cate.first?.name ?? "")
//        })
        
        JQNetworkTools.sharedInstance.requestData(methodName: "/cate/picList", type: .get, params: nil, finishCallback: {(result) in
//            let test1 = Mapper<TypeMD>().map(JSONObject: result)
//            print(test1?.data?.cate.first?.name ?? "")
            //let json = JSON(result).dictionary
           // guard let resultDict = json else { return }
            let type: TypesSATMD = TypesSATMD(dict: (result as? [String : NSObject])!)
            print(type.typesSATData?.pics.first?.picUrl ?? "")
            //print(json["ret"])
        })
    }
    
    func testPort() {
        var dict: Dictionary<String,Any> = Dictionary<String,Any>()
        dict["id"] = "100"
        dict["headPic"] = UIImage(named: "1")
        JQNetworkTools.sharedInstance.upLoadFileData(methodName: "/user/updateInfo", params: dict, finishCallback: {(reult) in
            
        })
        //        JQPhoneManagerVC.call(nil, self, failBlock: {
        //            print("拨打失败")
        //        })
    }
    
    func testRegex() {
        let contentStr = "how are you!"
        let regexEngRule = "o"
        contentStr.logResult(with: regexEngRule, contentStr: contentStr as NSString, resultsBlock: {(_location,_length) in
            print(NSMakeRange(_location, _length))
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let contentStr = "how are you!"
        let regexEngRule = "o"
        contentStr.logResult(with: regexEngRule, contentStr: contentStr as NSString, resultsBlock: {(_location,_length) in
                print(NSMakeRange(_location, _length))
            })
    }

}
