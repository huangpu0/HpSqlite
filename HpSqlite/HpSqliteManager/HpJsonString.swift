//
//  HpJsonString.swift
//  HpSqlite
//
//  Created by iTrader-dev on 2021/1/10.
//

import UIKit

class HpJsonString: NSObject {
    
    /**
     JSONString转换为字典
     
     - parameter jsonString: json字符串
     
     - returns: 字典
     */
    static func toJSONSerialization(_ jsonStr: String) -> [String : Any] {
        
        let jsonData:Data = jsonStr.data(using: .utf8) ?? Data.init()
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
        
        return dict as? [String : Any] ?? [:]
        
    }
    
    /**
     字典转换为JSONString
     
     - parameter dict: 字典参数
     
     - returns: JSONString
     */
    static func toJSONString(_ dict: [String: Any]) -> String {
        
        if (!JSONSerialization.isValidJSONObject(dict)) {
            print("无法解析出JSONString")
            return ""
        }
        let data: Data = try! JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)
        return String.init(data: data, encoding: .utf8) ?? ""
    }

}

