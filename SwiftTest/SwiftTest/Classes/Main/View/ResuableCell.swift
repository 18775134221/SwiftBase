//
//  ResuableCell.swift
//  SwiftTest
//
//  Created by MAC on 2017/1/20.
//  Copyright © 2017年 MAC. All rights reserved.
//

import UIKit

class ResuableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - 遵守重用的协议
extension ResuableCell: ViewNameReusable {
}
