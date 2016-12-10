//
//  BaseTabBarVC.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class BaseTabBarVC: UITabBarController {

    fileprivate var homeVC: HomeVC? = nil
    fileprivate var typesVC: TypesVC? = nil
    fileprivate var shoppingCartVC: ShoppingCartVC? = nil
    fileprivate var mineVC: MineVC? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}

extension BaseTabBarVC {
    
    fileprivate func setupUI() {
        setupChildVCs()
        setupTabBar()
    }
    
    // 设置自定义的TabBar
    private func setupTabBar() {
        
        
        UITabBar.appearance().tintColor = UIColor.orange
        
        let baseTabBar: BaseTabBar = BaseTabBar()
        baseTabBar.type = .plusDefault
        // 隐藏系统顶部tabBar的黑线
        baseTabBar.shadowImage = UIImage()
        baseTabBar.backgroundImage = UIImage()
        baseTabBar.backgroundColor = UIColor(r: 0.62, g: 0.03, b: 0.05)
        setValue(baseTabBar, forKey: "tabBar")
    }
    
    private func setupChildVCs() {
    
        homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
        addChildVC(homeVC!,"首页","icon_home_normal","icon_home_selected")
        
        typesVC = UIStoryboard(name: "Types", bundle: nil).instantiateViewController(withIdentifier: "TypesVC") as? TypesVC
        addChildVC(typesVC!,"分类","iocn_classification_normal","iocn_classification_selected")
        
        shoppingCartVC = UIStoryboard(name: "ShoppingCart", bundle: nil).instantiateViewController(withIdentifier: "ShoppingCartVC") as? ShoppingCartVC
        addChildVC(shoppingCartVC!,"购物车","icon_shopping-cart_normal","icon_shopping-cart_selected")
        
        mineVC = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "MineVC") as? MineVC
        addChildVC(mineVC!,"我的","icon_personal-center_normal","icon_personal-center_selected")
        
        
    
    }
    
    private func addChildVC(_ vc: UIViewController, _ title: String = "", _ normalImage: String = "",_ selectedImage: String = "") {
        
        vc.title = title;
        vc.tabBarItem.selectedImage = UIImage(named: selectedImage)
        vc.tabBarItem.image = UIImage(named: normalImage)
        let baseNaviVC: BaseNavigationVC = BaseNavigationVC(rootViewController: vc)
        addChildViewController(baseNaviVC)
    
    }
    
}

extension BaseTabBarVC: UITabBarControllerDelegate {

    // 选中底部导航按钮回调
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
}
