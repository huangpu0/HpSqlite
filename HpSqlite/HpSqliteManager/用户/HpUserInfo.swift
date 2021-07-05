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
            try db1?.run(table.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (new_db) in
                new_db.column(userId)
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
    
    /// 表的重命名
    /// - Parameters:
    ///   - old: 旧表
    ///   - new: 新表
    /// - Returns:
    func reset(_ old: String, new: String) -> Void {
        do {
            try db1?.run(Table(old).rename(Table.init(new)))
        } catch  {
            debugPrint(" old table reset new table =\(old) \n error=\(error.localizedDescription)")
        }
    }
    
    
    func add(_ dict: [String:Any]) -> Void {
        // 插入数据
        let u_Id   = dict["id"] as? Int ?? 0
        let u_Name = dict["name"] as? String ?? ""// 用户名字
        let u_Desc = dict["desc"] as? String ?? ""// 用户描述
        let u_original: String = HpJsonString.toJSONString(dict)
        let insert = table.insert(or: .replace, userId <- u_Id, userName <- u_Name, userDesc <- u_Desc, operate <- Date.init(), original <- u_original)
        if let rowId = try? db1?.run(insert) {
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
        if let exist = try? db1?.run(user.delete()) {
            print("删除==\(exist)")
        }else{
            print("删除失败")
        }
    }
    
    func deleteTab() -> Void {
        
        /// 表行数 计算
//        var count: Double = 0.0
//        do {
//            try  count = db1?.scalar(table.select(userId.average)) ?? 0.0
//        } catch  {
//            print("kk==\(error.localizedDescription)")
//        }
        
        /// 重命令表
//        do {
//            try db1?.run(table.rename(Table.init("newuser")))
//        } catch  {
//            print("kkk----\(error.localizedDescription)")
//        }
        
         userName ?? original
        
        
        /// 创建表索引
        do {
            try db1?.run(table.createIndex(userId))
        } catch  {
            print("创建表索引--\(error.localizedDescription)")
        }
        do {
            try db1?.execute(
                "sssssssssssss")
            
        }catch {
                
            }
        
//        if let exist = try? db1?.run(table.drop()) {
//            print("删除表==\(exist)")
//        }else{
//            print("删除失败")
//        }
      
        //return count
    }
    
    func newcopy() -> Void {
        if let eixt =  try? db1?.run(table.addColumn(Expression<String>("kkkk"), check: Expression<Bool?>(value: true), defaultValue: "sss")) {
            print("ok==\(eixt)")
        }else{
            print("faril")
        }
        
    }
    
    func cratNew() -> Void {
        
    }
}

// MARK: - 改
extension HpUserInfo {
    
    func update(_ id: Int) -> Void {
        let user = table.filter(userId == id)
        var old:[String:Any]  = self.query(id) ?? [:]
        old["name"] = "名字修改"
        if let exist = try? db1?.run(user.update(userName <- "名字修改", original <- HpJsonString.toJSONString(old))) {
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
        for user in try! db1!.prepare(query1) {
            print("email: \(user[original])")
            let old = user[original]
            data = HpJsonString.toJSONSerialization(old)
        }
        return data
    }
    
}
