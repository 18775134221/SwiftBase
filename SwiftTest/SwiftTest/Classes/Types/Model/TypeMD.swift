//
//  TypeMD.swift
//  SwiftTest
//
//  Created by MAC on 2017/2/9.
//  Copyright © 2017年 MAC. All rights reserved.
//

import UIKit
import ObjectMapper

class TypeMD: Mappable {

    var ret: Int = 0

    var data: TypeData?

    var msg: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        ret <- map["ret"]
        data <- map["data"]
        msg <- map["msg"]
    }
    
}
class TypeData: Mappable {

    var pic: [TypePic]?

    var cate: [TypeCate]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        pic <- map["pic"]
        cate <- map["cate"]
    }

}

class TypePic: Mappable {

    var picUrl: String?

    var prodId: Int = 0

    var text1: String?

    var price: Int = 0

    var text2: String?

    var storeId: Int = 0

    var link: String?

    var type: Int = 0
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        picUrl <- map["picUrl"]
    }

}

class TypeCate: Mappable {

    var picUrl: String?

    var id: Int = 0

    var subList: [TypeSublist]?

    var grade: Int = 0

    var name: String?

    var parId: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
    }

}

class TypeSublist: Mappable {

    var parId: Int = 0

    var id: Int = 0

    var grade: Int = 0

    var name: String?

    var picUrl: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
    }

}

