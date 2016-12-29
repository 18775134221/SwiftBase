//
//  JQCarouselCell.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/28.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class JQCarouselCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        var constraintArray: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[imageView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imageView": imageView])
        constraintArray += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[imageView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imageView": imageView])
        addConstraints(constraintArray)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
