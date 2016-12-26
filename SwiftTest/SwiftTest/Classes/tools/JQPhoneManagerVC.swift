//
//  JQPhoneManagerVC.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/14.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

// MARK: - 拨打电话
class JQPhoneManagerVC: UIViewController {

    
    var  webView: UIWebView?
    
    init () {
        webView = UIWebView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeFromParentViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    /**
     *  打电话
     *
     *  @param no                   电话号码
     *  @param inViewController     需要打电话的控制器
     */
    class func call(_ no: String?, _ inViewController: UIViewController?,failBlock: ()->()) {
    
        guard no != nil else {
            failBlock()
            return
        }
        // 拨打电话
        let noString: String = "tel://" + no!
        let url: NSURL = NSURL(string: noString)!;
        let canOpen: Bool? = UIApplication.shared.openURL(url as URL)
        if canOpen == false { // 可选类型才可以使用可选绑定 对象才可以置空
            failBlock()
            return
        }
        
        let pMVC: JQPhoneManagerVC = JQPhoneManagerVC()
        pMVC.view.alpha = 0
        pMVC.view.frame = CGRect.zero
        inViewController?.addChildViewController(pMVC)
        
        inViewController?.view.addSubview(pMVC.view)
        
        let request: NSURLRequest = NSURLRequest(url: url as URL)
        pMVC.webView?.loadRequest(request as URLRequest)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    deinit {
        webView = nil
        print("PhoneManager已经被释放")
    }

}
