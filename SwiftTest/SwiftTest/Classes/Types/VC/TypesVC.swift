//
//  TypesVC.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class TypesVC: BaseVC {

    let label_AnyO = UILabel().then { (label) in
        label.backgroundColor = .blue
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "Then库写法_2"
        label.frame = CGRect.init(x: 200, y: 260, width: 150, height: 40)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.addSubview(label_AnyO)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        JQPhoneManagerVC.call(nil, self, failBlock: {
            print("拨打失败")
        })
    }

}
