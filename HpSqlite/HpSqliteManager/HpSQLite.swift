//
//  HpSQLite.swift
//  HpSqlite
//
//  Created by iTrader-dev on 2021/4/1.
//

// TODO: https://blog.csdn.net/kyl282889543/article/details/100200012

import UIKit
import SQLite

private let AppName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName")
public  let db: Connection = HpSQLite.share.getdb()

class HpSQLite: NSObject {
    
    static let share = HpSQLite.init()
    
    fileprivate let fileName: String = "SQLiteFile"

    /// 获取db
    func getdb() -> Connection {
        let path    = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let db_File = path + "/" + fileName
        debugPrint("数据库地址=========\(db_File)")
        do{
            try FileManager.default.createDirectory(atPath: db_File, withIntermediateDirectories: true, attributes: nil)
        }catch {
            debugPrint("数据库创建Error-\(error)")
        }
        return try! Connection("\(db_File)/\(AppName ?? "SQLite").db")
    }
    
}

//MARK: -  表sq语句
extension HpSQLite {
    
    /// sq语句
    /// - Parameter sql: sql语句
    /// - Returns:
    func executeSql(_ sql:String) -> Void {
        do {
            try db.execute(sql)
        } catch {
            debugPrint(" executeSql Error==\(error.localizedDescription)")
        }
    }
    
}

//MARK: -  表升级扩展
extension HpSQLite {
    
    /// - Parameters: 表中是否含有此字段
    ///   - table:  表名字
    ///   - key:  字段名字
    /// - Returns: 是否存在
    func isExist(_ table:String, key: String) -> Bool {
        var columnDatas:[String] = []
        do {
            let datas = try db.prepare("PRAGMA table_info(" + table + ")")
            for row in datas  {
                columnDatas.append(row[1] as? String ?? "")
            }
        } catch {
            debugPrint(" query table column name Error==\(error.localizedDescription)")
        }
        let list = columnDatas.filter { (item) -> Bool in
            return item == key
        }
        return list.count > 0
    }
    
}

// MARK: - 增
extension HpSQLite {
    
    /// 表中新加入字段、默认类型 String? Int?
    /// - Parameters:
    ///   - table: 表名字
    ///   - key: 字段名
    ///   - keyValue: 初始Column
    /// - Returns:
    func add(_ table:String, key: String, keyValue: Any, defalutValue: Any?) -> Void {
        
        guard !self.isExist(table, key: key) else {
            debugPrint("table=\(table)==含有‘\(key)’字段")
            return
        }
        do {
            if let new_kv = keyValue as? Expression<Int?>, let v = defalutValue {
                try db.run(Table(table).addColumn(new_kv, defaultValue: v as? Int ?? nil))
            }else if let new_kv = keyValue as? Expression<String?>, let v = defalutValue {
                try db.run(Table(table).addColumn(new_kv, defaultValue: v as? String ?? nil))
            }
        } catch  {
            debugPrint(" table=\(table)\n add Error=\(error.localizedDescription)")
        }
        
    }
    
}

// MARK: - 删
extension HpSQLite {
    
    /// 删除一张表
    /// - Parameter name: 表名
    /// - Returns: 
    func delete(_ name: String) -> Void {
        do {
            try db.run(Table(name).drop())
        } catch  {
            debugPrint(" delete table =\(name) \n error=\(error.localizedDescription)")
        }
    }

}

// MARK: - 表重命名
extension HpSQLite {
    
    /// 表的重命名
    /// - Parameters:
    ///   - old: 旧表
    ///   - new: 新表
    /// - Returns:
    func reset(_ old: String, new: String) -> Void {
        do {
            try db.run(Table(old).rename(Table.init(new)))
        } catch  {
            debugPrint(" old table reset new table =\(old) \n error=\(error.localizedDescription)")
        }
    }
    
}

// MARK: - 表copy
extension HpSQLite {
    
    /// 表的重命名
    /// - Parameters:
    ///   - old: 旧表
    ///   - new: 新表
    /// - Returns:
    func copy(_ old: String, new: String) -> Void {
        do {
            try db.run(Table(old).rename(Table.init(new)))
        } catch  {
            debugPrint(" old table reset new table =\(old) \n error=\(error.localizedDescription)")
        }
    }
    
}
// MARK: - 批量处理
extension HpSQLite {
    
    func transaction() -> Void {
        do {
            try db.transaction(block: {
                // Code
            })
        } catch  {
            print(" 批量error=\(error.localizedDescription)")
        }
    }
    
}

