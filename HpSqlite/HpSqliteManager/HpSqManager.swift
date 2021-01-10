//
//  HpSqManager.swift
//  HpSqlite
//
//  Created by iTrader-dev on 2021/1/10.
//

import UIKit
import SQLite

private let App_Name = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName")

public let db: Connection? = HpSqManager.share.getdb()

class HpSqManager: NSObject {

    static let share = HpSqManager.init()
    
    fileprivate let file_name: String = "SqFile"

    /// 获取db
    func getdb() -> Connection? {
        let path    = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let db_File = path + "/" + file_name
        print("数据库地址=========\(db_File)")
        do{
           try FileManager.default.createDirectory(atPath: db_File, withIntermediateDirectories: true, attributes: nil)
        }catch {
            print("数据库文件Error-\(error)")
        }
        return try? Connection("\(db_File)/\(App_Name ?? "Sqlite").db")
    }
    
    /// 获取table
    func getTable(_ name: String) -> Table {
        return Table(name)
    }
    
    /// 创建table
    func creatTable() -> Void {
        HpUserInfo.share.creatTable()
    }
}
