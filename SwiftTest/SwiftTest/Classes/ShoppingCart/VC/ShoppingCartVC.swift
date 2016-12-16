//
//  ShoppingCartVC.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class ShoppingCartVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        ToastView.instance.showToast(content: "我是提示框")
//        ToastView.instance.showLoadingView()
        //ToastView.instance.clear()
        JQAlertVC.alertVC(vc: self, title: "提示", detailMsg: "我是提示信息", cancleTitle: nil, sureTitle: "确定", cancleCallback: { () -> () in }
        , sureCallback: { ()->() in
            debugLog("确定")
        })

    }

}
