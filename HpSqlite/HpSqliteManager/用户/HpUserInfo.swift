//
//  HpUserInfo.swift
//  HpSqlite
//
//  Created by iTrader-dev on 2021/1/10.
//

import UIKit
import SQLite

private let userId   = Expression<Int>("user_id") // 用户id
private let userName = Expression<String?>("user_name") // 用户名字
private let userDesc = Expression<String?>("user_desc") // 用户描述
private let operate  = Expression<Date>("operateTime")  // 最后操作时间
private let original = Expression<String>("original") // 原始数据

/// 用户表
private let table: Table = HpSqManager.share.getTable("userInfo")

class HpUserInfo: NSObject {
    
    static let share = HpUserInfo.init()
    
    func creatTable() -> Void {
        do {
            try db?.run(table.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (new_db) in
                new_db.column(userId, primaryKey: true)
                new_db.column(userName)
                new_db.column(userDesc)
                new_db.column(operate)
                new_db.column(original)
            }) )
        }catch  {
            print("\(error.localizedDescription)")
        }
    }
    
}

// MARK: - 增
extension HpUserInfo {
    
    func add(_ dict: [String:Any]) -> Void {
        // 插入数据
        let u_Id   = dict["id"] as? Int ?? 0
        let u_Name = dict["name"] as? String ?? ""// 用户名字
        let u_Desc = dict["desc"] as? String ?? ""// 用户描述
        let u_original: String = HpJsonString.toJSONString(dict)
        let insert = table.insert(userId <- u_Id, userName <- u_Name, userDesc <- u_Desc, operate <- Date.init(), original <- u_original)
        if let rowId = try? db?.run(insert) {
            print("插入成功：\(rowId)")
        } else {
            print("插入失败")
        }
    }
    
}

// MARK: - 删
extension HpUserInfo {
    
    func delete(_ id: Int) -> Void {
        let user = table.filter(userId == id)
        if let exist = try? db?.run(user.delete()) {
            print("删除==\(exist)")
        }else{
            print("删除失败")
        }
    }
    
}

// MARK: - 改
extension HpUserInfo {
    
    func update(_ id: Int) -> Void {
        let user = table.filter(userId == id)
        var old:[String:Any]  = self.query(id) ?? [:]
        old["name"] = "名字修改"
        if let exist = try? db?.run(user.update(userName <- "名字修改", original <- HpJsonString.toJSONString(old))) {
            print("修改后数据===\(self.query(id))")
        }else{
            print("删除失败")
        }
    }
    
}

// MARK: - 查
extension HpUserInfo {
    
    func query(_ id: Int) -> [String:Any]? {
        var data:[String:Any] = [:]
        let query1 = table.filter(userId == id).select(original).order(userId.desc).limit(1, offset: 0)
        for user in try! db!.prepare(query1) {
            print("email: \(user[original])")
            let old = user[original]
            data = HpJsonString.toJSONSerialization(old)
        }
        return data
    }
    
}
