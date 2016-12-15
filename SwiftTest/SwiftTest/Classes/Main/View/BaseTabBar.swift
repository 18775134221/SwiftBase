//
//  BaseTabBar.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
enum plusLocation {
    case plusDefault
    case plusUp
}

class BaseTabBar: UITabBar {
    
    var type: plusLocation? = .plusDefault
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count: Int = (items?.count)! + 1
        let btnW: CGFloat = UIScreen.main.bounds.size.width / CGFloat(count)
        let btnH: CGFloat = 49.0;
        var i: Int = 0
        
        for (_,button) in self.subviews.enumerated() {
            if button.isKind(of: NSClassFromString("UITabBarButton")!) {
                if 2 == i {
                    i += 1
                }
                button.frame = CGRect(x: btnW * CGFloat(i), y: 0, width: btnW, height: btnH)
                i += 1
                
            
            }
            
            if type == .plusDefault {
                pBtn.center = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
            }else{
                pBtn.center = CGPoint(x: frame.size.width * 0.5, y: 0)
            }

        }
    }
    
    
    fileprivate lazy var pBtn: UIButton = {[unowned self] in
        
        let btn: UIButton = UIButton(type:.custom)
        btn.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn.backgroundColor = UIColor.red
        btn.sizeToFit()
        self.addSubview(btn)
        return btn
    }()
    
    // 重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if false == self.isHidden {
            let nPoint: CGPoint = convert(point, to: pBtn)
            if pBtn.point(inside: nPoint, with: event) {
                return pBtn
            }else{
               return super.hitTest(point, with: event)
            }
        }else{
            return super.hitTest(point, with: event)
        }
        
    }
    
    
}


