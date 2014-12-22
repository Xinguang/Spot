//
//  AppSettingTable.swift
//  spot
//
//  Created by Hikaru on 2014/12/09.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation

class AppSettingTable {
    //シングルトンパターン
    class var instance: AppSettingTable {
        dispatch_once(&Inner.token) {
            Inner.instance = AppSettingTable()
        }
        return Inner.instance!
    }
    private struct Inner {
        static var instance: AppSettingTable?
        static var token: dispatch_once_t = 0
    }
    
    let tableName = "AppSettingTable"
    let columns:[String: SwiftData.DataType] = [
        
        /////////////////////////////
        ///微信///////////////////////
        /////////////////////////////
        "wx_access_token": .StringVal,
        "wx_openid": .StringVal,
        "wx_refresh_token": .StringVal,
        "wx_expires_in": .StringVal,
        "wx_updatetime": .StringVal
    ];
    
    private init() {
        let (tb, err) = SD.existingTables()
        if !contains(tb, tableName) {
            
            if let err = SD.createTable(tableName, withColumnNamesAndTypes: columns) {
                //there was an error during this function, handle it here
            } else {
                //no error, the table was created successfully
            }
        }
        println(SD.databasePath())
        
        let err_delete = SD.deleteTable(tableName)
    }
    
    
    
    func add(param:Dictionary<String, AnyObject>,prefix:String){
        var sql_columns = "";
        var sql_values = "";
        var atgs:[AnyObject] = [];
        
        for (key, value) in param {
            if(!contains(columns.keys, prefix+key)){ continue; }
            if ("" != sql_columns){
                sql_columns = sql_columns + ","
                sql_values = sql_values + ","
            }
            sql_columns = sql_columns + prefix+key
            sql_values = sql_values + "?"
            atgs.append(value)
        }
        if("" == sql_columns ) {return }
        
        NSLog("INSERT INTO \(tableName) (\(sql_columns)) VALUES (\(sql_values))")
        /*
        if let err = SD.executeChange("INSERT INTO \(tableName) (\(sql_columns)) VALUES (\(sql_values))", withArgs: atgs) {
            //there was an error during the insert, handle it here
        } else {
            //no error, the row was inserted successfully
        }
        */
    }
}