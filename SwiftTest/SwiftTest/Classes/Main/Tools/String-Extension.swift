//
//  String-Extension.swift
//  SwiftTest
//
//  Created by MAC on 2016/12/31.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

extension String{
    /**
     将当前字符串拼接到cache目录后面
     */
    func cacheDir() -> String{
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!  as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到doc目录后面
     */
    func docDir() -> String
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!  as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到tmp目录后面
     */
    func tmpDir() -> String
    {
        let path = NSTemporaryDirectory() as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    
    // MARK: - 获取十六进制的值
    func hexValue() -> Int {
        let str = self.uppercased()
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
    
    func size(withFont font: UIFont, maxWidth: CGFloat) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 5
        paragraphStyle.paragraphSpacing = 0
        let attributes = [NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle] as [String : Any]
        
        let string = self as NSString
        let newSize = string.boundingRect(with: CGSize.init(width: maxWidth, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                          attributes: attributes,
                                          context: nil).size
        return CGSize.init(width: CGFloat(ceilf(Float(newSize.width))), height: newSize.height)
    }
    
    /// URL编码
    func stringByAddingPercentEncoding() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    // MARK: - 通过正则表达式查找相应字符串在内容字符串的位置
    // 构建正则表达式
    func logResult(with regexRule: String, contentStr: NSString, resultsBlock:( (_location: Int, _length: Int)) -> ()) {
        let regex = try! NSRegularExpression(pattern: regexRule, options: .caseInsensitive)
        let results = regex.matches(in: contentStr as String, options: .withoutAnchoringBounds, range: NSMakeRange(0, contentStr.length))
        for matchResult in results {
            let matchStr = contentStr.substring(with: matchResult.range)
            print("result: \(matchStr), rang:(\(matchResult.range.location),\(matchResult.range.length))")
            resultsBlock((_location: matchResult.range.location,_length: matchResult.range.length))
        }
        /* 使用方式
        let contentStr = "how are you!"
        let regexEngRule = "o"
        contentStr.logResult(with: regexEngRule, contentStr: contentStr as NSString, resultsBlock: {(_location,_length) in
            print(NSMakeRange(_location, _length))
        })
        */
    }

}
