//
//  PoperMenuCell.swift
//  SwiftTest
//
//  Created by MAC on 2017/2/15.
//  Copyright © 2017年 MAC. All rights reserved.
//

import UIKit

class PoperMenuCell: UITableViewCell {

    var line: UIView?
    var menuModel: PoperMenuMD! {
        didSet {
            self.imageView?.image = UIImage(named: menuModel.imageName ?? "")
            self.textLabel?.text = menuModel.itemName
        }
    }
    
    override  func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        line = UIView()
        line?.backgroundColor = .lightGray
        addSubview(line!)
        self.backgroundColor = UIColor.clear
        self.textLabel?.font = UIFont.systemFont(ofSize: 14)
        self.textLabel?.textColor = .white
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        line?.frame = CGRect(x: 4, y: bounds.height - 1, width: bounds.width - 8, height: 0.5)
    }

}

// MARK: - 遵守协议
extension PoperMenuCell: ViewNameReusable {}
