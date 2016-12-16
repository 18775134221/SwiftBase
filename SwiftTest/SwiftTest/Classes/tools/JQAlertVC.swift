//
//  JQAlertVC.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/16.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class JQAlertVC: UIViewController {

    // 单例
//    static var shareInstance = JQAlertVC()
    
     class func alertVC(vc: UIViewController ,title: String? = nil, detailMsg: String? = nil, cancleTitle: String? = nil, sureTitle: String? = nil, cancleCallback: @escaping () -> ()?, sureCallback: @escaping () -> ()?) {
        
        let alertVC: UIAlertController = UIAlertController.init(title: title ?? nil, message: detailMsg ?? nil, preferredStyle: UIAlertControllerStyle.alert)
        
        if cancleTitle != nil {
            let cancleAction: UIAlertAction = UIAlertAction(title: cancleTitle, style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                cancleCallback()
                
            })
            cancleAction.setValue(UIColor.black, forKey: "_titleTextColor")
            alertVC.addAction(cancleAction)
        }

        if sureTitle != nil {
            let sureAction: UIAlertAction = UIAlertAction(title: sureTitle, style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
                sureCallback()
            })
            // 系统默认的颜色是蓝色，使用kvc修改颜色
           sureAction.setValue(UIColor.black, forKey: "_titleTextColor")
            alertVC.addAction(sureAction)
        }
        vc.present(alertVC, animated: true, completion: {
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    deinit {
        debugLog("弹窗释放了")
    }
}
