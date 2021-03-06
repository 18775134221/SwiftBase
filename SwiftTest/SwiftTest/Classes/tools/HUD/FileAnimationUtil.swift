//
//  FileAnimationUtil.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/15.
//  Copyright © 2016年 MAC. All rights reserved.
//

import Foundation
import UIKit

class AnimationUtil{
    
    
    static func getLoadToastAnimation(duration:CFTimeInterval = 3.0) -> CAAnimation{
    
        // 大小变化动画
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0.0,0.2];
        scaleAnimation.values = [0.8,1]
        // 上面的参数是 0.1秒 0->0.8  0.2秒 0.8-1
        scaleAnimation.duration = duration
        scaleAnimation.autoreverses = true
        scaleAnimation.fillMode = kCAFillModeBackwards

        
        // 透明度变化动画
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimaton.keyTimes = [0, 0.8]
        opacityAnimaton.values = [0.5, 1]
        opacityAnimaton.duration = duration
        
        // 组动画
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, opacityAnimaton]
        //动画的过渡效果1. kCAMediaTimingFunctionLinear//线性 2. kCAMediaTimingFunctionEaseIn//淡入 3. kCAMediaTimingFunctionEaseOut//淡出4. kCAMediaTimingFunctionEaseInEaseOut//淡入淡出 5. kCAMediaTimingFunctionDefault//默认
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = duration
        animation.repeatCount = 0// HUGE
        animation.isRemovedOnCompletion = true

        return animation
    }
    
    
    //弹窗动画
    static func getToastAnimation(duration:CFTimeInterval = 3.0) -> CAAnimation{
        // 大小变化动画
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0, 0.1, 0.9, 1]
        scaleAnimation.values = [0.5, 1, 1,0.5]
        scaleAnimation.duration = duration

        
        // 透明度变化动画
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimaton.keyTimes = [0, 0.8, 1]
        opacityAnimaton.values = [0.5, 1, 0]
        opacityAnimaton.duration = duration
        
        // 组动画
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, opacityAnimaton]
        //动画的过渡效果1. kCAMediaTimingFunctionLinear//线性 2. kCAMediaTimingFunctionEaseIn//淡入 3. kCAMediaTimingFunctionEaseOut//淡出4. kCAMediaTimingFunctionEaseInEaseOut//淡入淡出 5. kCAMediaTimingFunctionDefault//默认
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        animation.duration = duration
        animation.repeatCount = 0// HUGE
        animation.isRemovedOnCompletion = true
        animation.autoreverses = true
        animation.fillMode = kCAFillModeBackwards
        
        return animation
    }
}
