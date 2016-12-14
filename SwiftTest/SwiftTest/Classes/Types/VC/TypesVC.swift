//
//  TypesVC.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class TypesVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        JQPhoneManagerVC.call("10086", self, failBlock: {
            print("拨打失败")
        })
    }

}
