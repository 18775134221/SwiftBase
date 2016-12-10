//
//  BaseVC.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension BaseVC {

    // 设置导航条
    fileprivate func setupNaviBar() {
        
        // 1.去除导航栏高斯模糊
        navigationController?.navigationBar.isTranslucent = false
        
        // 2.修改导航条的颜色
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.00)
        
        // 3.修改导航条标题颜色
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // 4.修改导航条添加的按钮（item）颜色(黄色)
        navigationController?.navigationBar.tintColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.00)
        
        // 5.去除导航栏黑色分界线
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // 6.设置返回键标题
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        

    }

}
