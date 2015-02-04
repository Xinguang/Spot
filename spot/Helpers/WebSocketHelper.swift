//
//  WebSocketHelper.swift
//  spot
//
//  Created by Hikaru on 2015/01/26.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import UIKit

@objc protocol WebSocketHelperDelegateObjectiveC{
    optional func whenSuccess(ReceiveData:NSData)//成功
    optional func showInfo(info:String)//成功
    optional func whenReachable(isWifi:Bool)//联网
    optional func whenUnreachable()//断网
}

protocol WebSocketHelperDelegate:WebSocketHelperDelegateObjectiveC{
    func whenError(errMessage:String)//失败
    func whenSuccess(ReceiveMessage:String)//成功
}

class WebSocketHelper: NSObject, WebSocketDelegate {
    /* 開発室
    private var scheme = "ws"
    private var host = "192.168.10.161:9000"
    private var path = "/echobot"
    private var protocols = ["chat", "superchat"]
    */
    //AWS
    private var scheme = "ws"
    private var host = "54.92.98.113"
    private var path = "/socket.io/?EIO=2&transport=websocket"
    private var protocols = ["chat", "superchat"]
    
    
    private var socketEvent = "chat"
    
    
    private var issocketio = false;
    var socket:WebSocket?
    var delegate:WebSocketHelperDelegate?
    
    let reachability = Reachability.reachabilityForInternetConnection()
    
    //シングルトンパターン
    class var instance: WebSocketHelper {
        dispatch_once(&Inner.token) {
            Inner.instance = WebSocketHelper()
        }
        return Inner.instance!
    }
    private struct Inner {
        static var instance: WebSocketHelper?
        static var token: dispatch_once_t = 0
    }
    
    //初期化
    private override init() {
        super.init()
        self.issocketio = self.path =~ "socket.io"
        self.socket = WebSocket(url: NSURL(scheme: self.scheme, host: self.host, path: self.path)!, protocols: self.protocols)
        self.socket?.delegate = self
        self.socket?.connect()
        
        self.reachability.whenReachable = { reachability in
            if let so = self.socket? {
                if(!so.isConnected){
                    self.socket?.connect()
                    self.delegate?.whenReachable?(self.reachability.isReachableViaWiFi())
                }
            }
        }
        self.reachability.whenUnreachable = { reachability in
            if let so = self.socket? {
                if(so.isConnected){
                    self.socket?.disconnect()
                    self.delegate?.whenUnreachable?()
                }
            }
        }
        
        reachability.startNotifier()
    }
    // MARK: Websocket Delegate Methods.
    
    func websocketDidConnect() {
        self.delegate?.showInfo?("websocket is connected");
    }
    
    func websocketDidDisconnect(error: NSError?) {
        if let e = error {
            self.delegate?.whenError("websocket is disconnected: \(e.localizedDescription)");
        }
    }
    
    func websocketDidWriteError(error: NSError?) {
        if let e = error {
            self.delegate?.whenError("we got an error from the websocket: \(e.localizedDescription)")
        }
    }
    
    func websocketDidReceiveMessage(text: String) {
        if self.issocketio {
            let res = text.match("(?<=42\\[\"\(self.socketEvent)\",)(.*)(?=\\])")//self.socketEvent
            if(res.count>0){
                self.delegate?.whenSuccess(res[0])
            }
        }else{
            self.delegate?.whenSuccess(text)
        }
        //self.delegate?.whenSuccess(text)
    }
    
    func websocketDidReceiveData(data: NSData) {
        self.delegate?.whenSuccess?(data)
    }
    
    func sendMessage(msg:String){
        if let so = self.socket? {
            if(so.isConnected){
                var str = msg;
                if self.issocketio {
                    str = self.createMessageForEvent(self.socketEvent, withArgs: [msg], hasBinary: false, withDatas: 0)
                }
                self.socket?.writeString(str)
            }else{
                self.delegate?.whenError("websocket is not connected");
            }
        }
    }
    func sendData(data:NSData){
        if let so = self.socket? {
            if(so.isConnected){
                self.socket?.writeData(data)
            }else{
                self.delegate?.whenError("websocket is not connected");
            }
        }
    }
    func connectToggle(){
        if let so = self.socket? {
            if(so.isConnected){
                self.socket?.disconnect()
            }else{
                self.socket?.connect()
            }
        }
    }
    
    //socket io message model
    private func createMessageForEvent(event:String, withArgs args:[AnyObject],
        hasBinary:Bool, withDatas datas:Int = 0) -> String {
            
            var message:String
            var jsonSendError:NSError?
            
            if !hasBinary {
                message = "42[\"\(event)\""
            } else {
                message = "45\(datas)-[\"\(event)\""
            }
            
            for arg in args {
                message += ","
                
                if arg is NSDictionary || arg is [AnyObject] {
                    let jsonSend = NSJSONSerialization.dataWithJSONObject(arg,
                        options: NSJSONWritingOptions(0), error: &jsonSendError)
                    let jsonString = NSString(data: jsonSend!, encoding: NSUTF8StringEncoding)
                    
                    message += jsonString!
                    continue
                }
                
                if arg is String {
                    message += "\"\(arg)\""
                    continue
                }
                
                message += "\(arg)"
            }
            
            return message + "]"
    }
}