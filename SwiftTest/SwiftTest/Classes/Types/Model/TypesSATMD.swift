//
//  TypesSATMD.swift
//  SwiftTest
//
//  Created by MAC on 2017/3/4.
//  Copyright © 2017年 MAC. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    
    init(dict: [String: AnyObject]) {
        super.init()
        //setValuesForKeys是KVC方法
        //KVC的方法又是OC的方法，在运行时给对象发送消息，这点要求对象已经实例化完成。super.init()就是用来保证对象初始化完成。
        setValuesForKeys(dict)
        
    }
    //重写父类的方法
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        //没有调用super，将父类的代码完全覆盖，不会崩溃
    }
}

class TypesSATMD: BaseModel {
    var msg: String = ""
    var ret: Int = 0
    var data: [String: NSObject]? {
        didSet {
            guard let tempData = data else { return }
            typesSATData = TypesSATData(dict: tempData)
        }
    }
    
    var typesSATData: TypesSATData?
}

class TypesSATData: BaseModel {
    var cate: [[String: NSObject]]? {
        didSet {
            guard let tempCate_list = cate else { return }
            for dict in tempCate_list {
                cates.append(TypesSATCate(dict: dict))
            }
        }
    }
    
    var pic: [[String: NSObject]]? {
        didSet {
            guard let banner_list = pic else { return }
            for dict in banner_list {
               pics.append(TypesSATPic(dict: dict))
            }
        }
    }
    var cates: [TypesSATCate] = [TypesSATCate]()
    var pics:[TypesSATPic] =  [TypesSATPic]() // 轮播图数组
    
}

class TypesSATCate: BaseModel {
    var grade: Int = 0
    var id: Int = 0
    var name: String = ""
    var parId: String = ""
    var picUrl: String = ""
    var subList: [[String: NSObject]]? {
        didSet {
            guard let tempSubList = subList else { return }
            for dict in tempSubList {
                subLists.append(TypesSATSubList(dict: dict))
            }
        }
    }
    
    var subLists: [TypesSATSubList] = [TypesSATSubList]()
}

class TypesSATPic: BaseModel {
    var link: String = ""
    var picUrl: String = ""
    var price: Double = 0
    var prodId: Int = 0
    var storeId: Int = 0
    var text1: String = ""
    var text2: String = ""
    var type: Int = 0
    
}

class TypesSATSubList: BaseModel {
    var grade: Int = 0
    var id: Int = 0
    var name: String = ""
    var parId: Int = 0
    var picUrl: String = ""
}
