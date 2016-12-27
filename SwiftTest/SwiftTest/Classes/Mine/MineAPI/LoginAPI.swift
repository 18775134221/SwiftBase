//
//  LoginAPI.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/27.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import Alamofire

enum LoginAPI {
    case Login(mobile: String?, auth_code: String?)
}

// MARK: - 遵守的协议要实现
extension LoginAPI: Request {
    var path: String {
        switch self {
        case .Login(_):
            return "Login"
        }
    }
    
    var method: HTTPMethod {
        return HTTPMethod.get
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .Login(let mobile,let auth_code):
            return [
                "phone": mobile!,
                "code": auth_code!
            ]
            
        }
    }
    
}
