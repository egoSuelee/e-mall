//
//  SQLiteManager.swift
//  HLProcurementSwift
//
//  Created by 彭仁帅 on 2017/1/13.
//  Copyright © 2017年 PigPRS. All rights reserved.
//

import UIKit

class SQLiteManager: NSObject {
    
    private static let manager: SQLiteManager = SQLiteManager()
    /// 单例
    class func shareManager() -> SQLiteManager {
        return manager
    }
    
    override init() {
        super.init()
        //根据传入的数据库名字拼接数据库路径
        let path = NSHomeDirectory().appending("/Documents/HLProcurement.db")
        
        //创建数据库对象
        dbqueue = FMDatabaseQueue(path: path)
    }
    
    var dbqueue:FMDatabaseQueue?
    
    /// 缓存数据(开起事物)
    ///
    /// - Parameters:
    ///   - dic: sql语句字典
    ///   - progress: 进度条显示闭包
    ///   - success: 成功闭包
    ///   - faile: 失败闭包
    class func cacheDataInTransaction(dic: [String: Any], progress: @escaping (_ pregress: Float,_ title: String) -> (), success: @escaping (()-> ()), faile: @escaping (() -> ()))
    {
        
        let SQL: String     = dic["SQL"] as! String
        let SQL1: String    = dic["SQL1"] as! String
        let SQL2: String    = dic["SQL2"] as! String
        let SQL2Arr: Array<String>  = dic["SQL2Arr"] as! Array<String>
        let dataArr: Array<Dictionary<String,Any>>  = dic["data"] as! Array<Dictionary<String, Any>>
        
        // 2.执行SQL语句
        SQLiteManager.shareManager().dbqueue?.inTransaction({ (db, rollback) -> Void in
            
            //删除原表
            db?.executeUpdate(SQL, withArgumentsIn: nil)
            //新建表
            db?.executeUpdate(SQL1, withArgumentsIn: nil)
            
            for i in 0..<dataArr.count {
                
                let dataDic: Dictionary<String,Any> = dataArr[i]
                
                var sql2 = ""
                
                for j in 0..<SQL2Arr.count {
                    
                    if let str = dataDic[SQL2Arr[j]] {
                        sql2 = sql2 + "," + "'\(str)'"
                    }else{
                        sql2 = sql2 + "," + "''"
                    }
                    
                }
                
                sql2 = SQL2 + sql2.substring(from: sql2.index(after: sql2.startIndex)) + ")"
                
                if db?.executeUpdate(sql2, withArgumentsIn: nil) == false
                {
                    // 如果插入数据失败, 就回滚
                    rollback?.pointee = true //pointee(指针)
                    faile()
                    return
                }else {
                    let p = Float(i)/Float(dataArr.count)
                    progress(p, "进度:\(i)/\(dataArr.count)")
                }
                
            }
            
            success()
        })
    }
    
    /// 缓存数据
    ///
    /// - Parameters:
    ///   - dic: sql语句字典
    ///   - success: 成功闭包
    ///   - faile: 失败闭包
    class func cacheData(dic: [String: Any], success: @escaping (()-> ()), faile: @escaping (() -> ()))
    {
        
        let SQL: String     = dic["SQL"] as! String
        let SQL1: String    = dic["SQL1"] as! String
        let SQL2: String    = dic["SQL2"] as! String
        let SQL2Arr: Array<String>  = dic["SQL2Arr"] as! Array<String>
        let dataArr: Array<Dictionary<String,Any>>  = dic["data"] as! Array<Dictionary<String, Any>>
        
        // 2.执行SQL语句
        SQLiteManager.shareManager().dbqueue?.inDatabase({ (db) -> Void in
            
            //删除原表
            db?.executeUpdate(SQL, withArgumentsIn: nil)
            //新建表
            db?.executeUpdate(SQL1, withArgumentsIn: nil)
            
            for i in 0..<dataArr.count {
                
                let dataDic: Dictionary<String,Any> = dataArr[i]
                
                var sql2 = ""
                
                for j in 0..<SQL2Arr.count {
                    
                    if let str = dataDic[SQL2Arr[j]] {
                        sql2 = sql2 + "," + "'\(str)'"
                    }else{
                        sql2 = sql2 + "," + "''"
                    }
                    
                }
                
                sql2 = SQL2 + sql2.substring(from: sql2.index(after: sql2.startIndex)) + ")"
                
                if db?.executeUpdate(sql2, withArgumentsIn: nil) == false
                {
                    //删除原表
                    db?.executeUpdate(SQL, withArgumentsIn: nil)
                    faile()
                    return
                }
                
            }
            success()

        })
    
    }
    
//    //读取数据
//    class func loadCacheStatuses(since_id: Int, max_id: Int, finished: @escaping ([[String: AnyObject]])->()) {
//        
//        // 1.定义SQL语句
//        
//        let sql = "SELECT * FROM T_message \n" + "WHERE type= '\(type)' \n" + "ORDER BY messageId DESC \n"
//        
//        // 2.执行SQL语句
//        SQLiteManager.shareManager().dbqueue?.inDatabase({ (db) -> Void in
//            
//            // 2.1查询数据
//            let res =  db.executeQuery(sql, withArgumentsInArray: nil)
//            
//            // 2.2遍历取出查询到的数据
//            // 返回字典数组的原因:通过网络获取返回的也是字典数组,
//            // 让本地和网络返回的数据类型保持一致, 以便于后期处理
//            var statuses = [[String: AnyObject]]()
//            while res.next()
//            {
//                // 1.取出数据库存储的一条微博字符串
//                let dictStr = res.stringForColumn("statusText") as String
//                // 2.将微博字符串转换为微博字典
//                let data = dictStr.dataUsingEncoding(String.Encoding.utf8)!
//                let dict = try! JSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [String: AnyObject]
//                statuses.append(dict)
//            }
//            
//            // 3.返回数据
//            finished(statuses)
//        })
//    }
}
