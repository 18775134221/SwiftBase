//
//  ShoppingCartVC.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

// MARK: - 优雅的管理selector
fileprivate struct Action {
    static let rightItemAction = #selector(ShoppingCartVC.viewClick(button:))
    static let leftItemAction = #selector(ShoppingCartVC.leftViewClick(button:))
    
}

extension Selector {
    static let toMenu = #selector(ShoppingCartVC.viewClick(button:))
    static let toExtra = #selector(ShoppingCartVC.leftViewClick(button:))
}


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
        images.append("https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1483148459&di=7771f39fded7c9f497581018a8293dc2&src=http://g.hiphotos.baidu.com/lvpics/h=800/sign=88930a220e2442a7b10ef0a5e142ad95/29381f30e924b899bfc349996f061d950b7bf697.jpg")
        images.append("https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1483148459&di=7771f39fded7c9f497581018a8293dc2&src=http://g.hiphotos.baidu.com/lvpics/h=800/sign=88930a220e2442a7b10ef0a5e142ad95/29381f30e924b899bfc349996f061d950b7bf697.jpg")
        Carouselview.imageGroups = images

        setupUI()
    }
    
    private func setupUI() {
        setupNarBar()
    }
    
    private func setupNarBar() {
        // 右边的按钮
        let button: UIButton = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.backgroundColor = .red
        button.addTarget(self, action: Action.rightItemAction, for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: button)
        rightItem.target = self
        rightItem.action = Selector.toMenu
        self.navigationItem.setRightBarButton(rightItem, animated: true)
        
        // 左边的按钮
        let leftButton: UIButton = UIButton(type: .custom)
        leftButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftButton.backgroundColor = .red
        leftButton.addTarget(self, action: Action.leftItemAction, for: .touchUpInside)
        let leftItem = UIBarButtonItem(customView: leftButton)
        self.navigationItem.setLeftBarButton(leftItem, animated: true)
    }
    
    @objc func leftViewClick(button: UIButton) {
        let view = PoperMenuView.init(frame: CGRect(x: 0, y: 64, width: 120, height: 0),view: button)
        let dict = ["imageName":"home2","itemName":"首页"]
        view.datasArray = [dict,dict,dict,dict,dict,dict,dict,dict,dict]
    }
    
    @objc func viewClick(button: UIButton) {
        let view = PoperMenuView.init(frame: CGRect(x: UIScreen.main.bounds.size.width - 120, y: 64, width: 120, height: 0),view: button)
        let dict = ["imageName":"home2","itemName":"首页"]
        view.datasArray = [dict,dict,dict,dict,dict,dict,dict,dict,dict]
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
        
        let view = PoperMenuView.init(frame: CGRect(x: 0, y: 0, width: 100, height: 0),view: self.view)
        let dict = ["imageName":"home2","itemName":"首页"]
        view.datasArray = [dict,dict,dict,dict,dict,dict,dict,dict,dict]
       //view.poperMenuViewShow()
  
    }

}
