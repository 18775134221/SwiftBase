//
//  UIImage-Extension.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/28.
//  Copyright © 2016年 MAC. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    // MARK: - 根据颜色创建Image
    class func createImage(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // MARK: 拉伸图片做背景
    class func getStretchableImage(imageName: String) -> UIImage {
        var image = UIImage(named: imageName)
        image = image?.stretchableImage(withLeftCapWidth: Int((image?.size.width)! * 0.5), topCapHeight: Int((image?.size.height)! * 0.5))
        return image!
    }
}
