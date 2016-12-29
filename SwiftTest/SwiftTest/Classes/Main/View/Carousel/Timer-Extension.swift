//
//  Timer-Extension.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/28.
//  Copyright © 2016年 MAC. All rights reserved.
//

import Foundation
import ObjectiveC

private typealias JQTimerBlock = () -> ()
private var otherS: AnyClass? = nil

extension Timer {
    
    // MARK: - 并不是真正的释放，只是
    fileprivate func jq_deinit() {
        var count : UInt32 = 0
        let ivars = class_copyIvarList(Timer.self, &count)!
        for i in 0..<count {
            let ivar = ivars[Int(i)]
            let name = ivar_getName(ivar)
            debugLog("--------\(String(cString: name!))")
                
            if ((String(cString: name!).range(of: "Timer")) != nil) {
                let tempTimer = object_getIvar(self, ivars[Int(i)]) as? Timer
                if let _ = tempTimer?.isValid {
                    tempTimer?.invalidate()
                }
            }
        }
         debugLog("--------交换)")
        self.jq_deinit()
    }
    
    // MARK: - 只会初始化一次，相当于OC中的dispatch_once
    static let onceGlobal: () = {
        let cls: AnyClass! = Timer.self
        let originalSelector = Selector(("deinit"))
        let swizzledSelector = Selector(("jq_deinit"))
        
        let originalMethod =
            class_getInstanceMethod(otherS, originalSelector)
        let swizzledMethod =
            class_getInstanceMethod(cls, swizzledSelector)
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }()
    
    /*
     *  @discussion NSTimer会强引用target而导致有可能出现循环引用的问题，该Category主要解决循环引用 并简单的实现自释放功能，一个对象的timer属性或变量并不需要考虑在合适的时机调用invalidate timer会在该对象销毁的时候自动invalidate。
     */
    class func jq_scheduled(timerInterval: TimeInterval, repeats: Bool? = false, target: AnyClass, block: JQTimerBlock) -> Timer {
        let cycleTimer: Timer = Timer(timeInterval: timerInterval, target: self, selector: #selector(p_blockInvoke(sender:)), userInfo: block, repeats: repeats!)
        otherS = target
        _ = onceGlobal
        return cycleTimer
    }
    
    class func p_blockInvoke(sender: Timer) {
        let block: JQTimerBlock = sender.userInfo as! JQTimerBlock
        block()
    }
    
    // 暂停
    func jq_pauseTimer() {
        if self.isValid == true {
            self.fireDate = NSDate.distantPast
        }
    }
    
    // 恢复
    func jq_resumeTimer() {
        jq_resumeTimerAfterTimerval(interval: 0)
    }
    
    func jq_resumeTimerAfterTimerval(interval: TimeInterval) {
        if self.isValid == false {
            self.fireDate = NSDate.init(timeIntervalSinceNow: interval) as Date
        }
    }
}
