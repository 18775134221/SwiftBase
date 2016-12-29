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
        // 必须写，不然UICollection上回初始布局错误
        automaticallyAdjustsScrollViewInsets = false
        
        let Carouselview: JQCarouselView = JQCarouselView.init(frame:CGRect.zero)
        view.addSubview(Carouselview)
        Carouselview.translatesAutoresizingMaskIntoConstraints = false
        var constraintArray: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[Carouselview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["Carouselview": Carouselview])
     
        constraintArray += NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[Carouselview(100)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["Carouselview": Carouselview])
        Carouselview.backgroundColor = UIColor.gray
        view.addConstraints(constraintArray)
        
        var images: [String] = [String]()
        images.append("1")
        images.append("2")
        images.append("3")
        images.append("1")
        images.append("2")
        images.append("3")
        Carouselview.imageGroups = images

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        ToastView.instance.showToast(content: "我是提示框")
//        ToastView.instance.showLoadingView()
        //ToastView.instance.clear()
        

//        JQAlertVC.alertVC(vc: self, title: "提示", detailMsg: "我是提示信息", cancleTitle: nil, sureTitle: "确定", cancleCallback: { () -> () in }
//        , sureCallback: { _ in
//            debugLog("确定")
//        })
        
//        let VC: TestVC = UIStoryboard.init(name: "ShoppingCart", bundle: nil).instantiateViewController(withIdentifier: "TestVC") as! TestVC
//        navigationController?.pushViewController(VC, animated: true)

    }

}
