//
//  WKDelegateVC.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/13.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import WebKit

@objc protocol WKDelegateVCDelegate {
   func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
}

class WKDelegateVC: UIViewController {

    weak var delegate: WKDelegateVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - 主要解决WKWebView不能释放的问题
extension WKDelegateVC: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}
