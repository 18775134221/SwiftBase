//
//  JQPageControlView.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/28.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

enum PagecontrolStyle {
    case colorBG // 使用颜色填充
    case imageBG // 使用颜色填充
}

@objc protocol JQPageControlViewDlegate {
    
    // 当前点击了第几个pageControl
   @objc optional func pageControlViewDidSelected(pageControlView: JQPageControlView, index: NSInteger)
}

protocol JQPageControlViewDatasource {
    func pageControlSizeAndSpace() -> (pointSize: CGFloat, distance: CGFloat)
    func pageControlColor() -> (currentColor: UIColor, otherColor: UIColor)
    func pageControlBG() -> (currentImageName: String, otherImageName: String)
}

class JQPageControlView: UIView {
    
    weak var delegate: JQPageControlViewDlegate?
    var datasource: JQPageControlViewDatasource?
    var currentPageControl: NSInteger? {
        didSet {
            setupCurrentPageControl(index: currentPageControl!)
        }
    }
    
    var numberPageControls: NSInteger? {
        didSet {
            setupUI()
        }
    }
    
    var pageControlStyle: PagecontrolStyle?
    
    override init(frame: CGRect) {
        pageControlStyle = .colorBG
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
    }
    
    // 设置当前选中的pageControl
    fileprivate func setupCurrentPageControl(index: NSInteger) {
        let numberPoints: Int = subviews.count
        for i in 0..<numberPoints {
            let imageV = subviews[i] as! UIImageView
            if index == i {
                if pageControlStyle == .colorBG {
                    imageV.backgroundColor = datasource?.pageControlColor().currentColor
                }else {
                    imageV.image = UIImage(named: (datasource?.pageControlBG().currentImageName)!)
                }

            }else {
                if pageControlStyle == .colorBG {
                    imageV.backgroundColor = datasource?.pageControlColor().otherColor
                }else {
                    imageV.image = UIImage(named: (datasource?.pageControlBG().otherImageName)!)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for view in subviews {
            // 大小
            let pointSize: CGFloat = (datasource?.pageControlSizeAndSpace().pointSize)!
            view.frame.origin.y = (bounds.size.height - pointSize) / 2.0
        }
    }
    
    
    
    fileprivate func setupUI() {
        
        backgroundColor = UIColor.clear
        
        // 清空
        for view in subviews {
            view.removeFromSuperview()
        }
        // 数量
        let numberPages: Int = numberPageControls!
        // 大小
        let pointSize: CGFloat = (datasource?.pageControlSizeAndSpace().pointSize)!
        // 间距
        let pointSpace: CGFloat = (datasource?.pageControlSizeAndSpace().distance)!
        // 居中
        var startX: CGFloat = 0
        
        let startY: CGFloat = (frame.height - pointSize) / 2.0
        for i in 0..<numberPages {
            let pointImageV = UIImageView()
            pointImageV.frame = CGRect(x: startX, y: startY, width: pointSize, height: pointSize)
            pointImageV.layer.cornerRadius = pointSize / 2.0
            pointImageV.layer.masksToBounds = true
            pointImageV.tag = i
            pointImageV.isUserInteractionEnabled = true
            addSubview(pointImageV)
            
            startX += pointSize + pointSpace
            // 添加点击手势
            let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tapGet:)))
            pointImageV.addGestureRecognizer(tap)
        }
        
        // 默认选中第一个
        currentPageControl = 0
        
        debugLog("当前  \(bounds)")
    }
    
    @objc fileprivate func tapAction(tapGet: UITapGestureRecognizer) {
        guard (delegate != nil) else {
            return
        }
        delegate?.pageControlViewDidSelected!(pageControlView: self, index: (tapGet.view?.tag)!)
    }

}
