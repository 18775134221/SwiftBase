//
//  BaseNavigationVC.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class BaseNavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenPOP()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
}

extension BaseNavigationVC {
    
    // MARK: - 添加全屏返回手势
    fileprivate func setupScreenPOP() {
        
        // 1.获取系统的Pop手势
        guard let systemGes = interactivePopGestureRecognizer else { return }
        
        // 2.获取手势添加到的View中
        guard let gesView = systemGes.view else { return }
        
        // 3.获取target/action
        // 3.1.利用运行时机制查看所有的属性名称
//         var count : UInt32 = 0
//         let ivars = class_copyIvarList(UITableViewRowAction.self, &count)!
//         for i in 0..<count {
//         let ivar = ivars[Int(i)]
//         let name = ivar_getName(ivar)
//             print(String(cString: name!))
//         }
//        free(ivars)
        
 
        let targets = systemGes.value(forKey: "_targets") as? [NSObject]
        guard let targetObjc = targets?.first else { return }
        
        // 3.2.取出target
        guard let target = targetObjc.value(forKey: "target") else { return }
        
        // 3.3.取出Action
        let action = Selector(("handleNavigationTransition:"))
        
        // 4.创建自己的Pan手势
        let panGes = UIPanGestureRecognizer()
        gesView.addGestureRecognizer(panGes)
        panGes.addTarget(target, action: action)
    
    }
    
    
}

extension BaseNavigationVC: UINavigationControllerDelegate {

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        navigationController?.hidesBottomBarWhenPushed = true
        
        super.pushViewController(viewController, animated: animated);
    }
}
