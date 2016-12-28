//
//  HomeVC.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import WebKit

class HomeVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        openUrl()
        
        NSObject.getFileSize(path: NSObject.cachesPath(), completionBlock: { (size) in
            print("当前文件大小\(CGFloat(size) / (1024.0 * 1024))")
        })


    }
    
    private func setupUI() {
        
    }
    
    private func openUrl() {
        let string: String = "http://www.baidu.com"
        let url: NSURL = NSURL(string:string)!
            //NSURL(string: string)!
        let request: NSURLRequest = NSURLRequest(url: url as URL, cachePolicy: NSURLRequest.CachePolicy(rawValue: 0)!, timeoutInterval: 15)
        wkWebView.load(request as URLRequest)
        
    }
    
    
    // MARK: - 懒加载
    lazy var wkWebView: WKWebView = {[weak self] in
        
        let wkDelegateVC: WKDelegateVC = WKDelegateVC()
        wkDelegateVC.delegate = self
        
        self?.configur.userContentController = (self?.usercontent)!
        // 配对出现，有添加一定要有移除
        self?.usercontent.add(wkDelegateVC, name: "NativeMethod")
        
        let webView: WKWebView = WKWebView(frame:CGRect.zero, configuration: (self?.configur)!)
        webView.frame = (self?.view.bounds)!
        self?.view.addSubview(webView)
        return webView
        }()
    
    lazy var usercontent: WKUserContentController = WKUserContentController()
    lazy var configur: WKWebViewConfiguration = WKWebViewConfiguration()
    
    deinit {
        usercontent.removeScriptMessageHandler(forName: "NativeMethod")
        print("dealloc")
    }
}

extension HomeVC: WKDelegateVCDelegate {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    }
}
