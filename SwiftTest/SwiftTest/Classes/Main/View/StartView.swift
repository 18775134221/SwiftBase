//
//  StartView.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/27.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import Foundation

class StartView: UIView {
    private let kStarCount: Int = 5
    var level: CGFloat! {
        didSet{
            var fullCount: Int = Int(level)
            // 满星部分
            for i in 0..<fullCount {
                self.makeStarView(imageNameStr: "", startPosition: i);
            }
            
            let m: CGFloat = level - CGFloat(fullCount)
            if m > 0 {
                self.makeStarView(imageNameStr: "", startPosition: fullCount);
                fullCount += 1
            }
            
            for j in fullCount..<kStarCount {
                self.makeStarView(imageNameStr: "", startPosition: j);
            }
        }
    }

    fileprivate func makeStarView(imageNameStr: String, startPosition: NSInteger) {
        var imageView: UIImageView?
        if subviews.count == kStarCount {
            imageView = subviews[startPosition] as? UIImageView
            imageView?.image  = UIImage(named: imageNameStr)
            return
        }
        
        imageView = UIImageView()
        imageView?.image = UIImage(named: imageNameStr)
        imageView?.sizeToFit()
        imageView?.frame = CGRect(x: (imageView?.frame.size.width)! * CGFloat(startPosition), y: 0, width: (imageView?.frame.size.width)!, height: (imageView?.frame.size.height)!)
        addSubview(imageView!)
    }

}
