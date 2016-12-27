//
//  LoginViewModel.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/27.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class LoginViewModel: NSObject {

   func Login () {
        _ = NetworkClient().send(LoginAPI.Login(mobile: "", auth_code: "")).subscribe { (result) in
            
    }
    }
}
