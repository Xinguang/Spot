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
    private var scheme = "ws"
    private var host = "192.168.10.161:9000"
    private var path = "/echobot"
    private var protocols = ["chat", "superchat"]
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
        self.delegate?.whenSuccess(text)
    }
    
    func websocketDidReceiveData(data: NSData) {
        self.delegate?.whenSuccess?(data)
    }
    
    func sendMessage(msg:String){
        if let so = self.socket? {
            if(so.isConnected){
                self.socket?.writeString(msg)
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
}