//
//  GestureRecognizerHelper.swift
//  spot
//
//  Created by Hikaru on 2014/12/26.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation

class GestureRecognizerHelper :NSObject{
    
    //シングルトンパターン
    class var instance: GestureRecognizerHelper {
        dispatch_once(&Inner.token) {
            Inner.instance = GestureRecognizerHelper()
        }
        return Inner.instance!
    }
    private struct Inner {
        static var instance: GestureRecognizerHelper?
        static var token: dispatch_once_t = 0
    }
    //初期化
    private override init() {
    }
    
    func LabelLongPress(view:UIView){
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "LongPressMenuAction:")
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGestureRecognizer)
        
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "LongPressMenuAction:"))
    }
    
    
    // Handle actions #CopyMessage
    // 1. Select row and show "Copy" menu
    func LongPressMenuAction(gestureRecognizer: UILongPressGestureRecognizer) {
        let twoTaps = (gestureRecognizer.numberOfTapsRequired == 2)
        let doubleTap = (twoTaps && gestureRecognizer.state == .Ended)
        let longPress = (!twoTaps && gestureRecognizer.state == .Began)
        if doubleTap || longPress {
            //let pressedIndexPath = tableView.indexPathForRowAtPoint(gestureRecognizer.locationInView(tableView))!
            //tableView.selectRowAtIndexPath(pressedIndexPath, animated: false, scrollPosition: .None)
            /*
            let menuController = UIMenuController.sharedMenuController()
            let view = gestureRecognizer.view!
            menuController.setTargetRect(view.frame, inView: view.superview!)
            menuController.menuItems = [UIMenuItem(title: "Copy", action: "messageCopyTextAction:")]
            menuController.setMenuVisible(true, animated: true)
            */
            let view = gestureRecognizer.view!
            var MenuController: UIMenuController = UIMenuController.sharedMenuController()
            MenuController.menuVisible = true
            MenuController.arrowDirection = UIMenuControllerArrowDirection.Down
            MenuController.setTargetRect(CGRectMake(100, 80, 50, 50), inView: view.superview!)
            
            MenuController.menuItems = [UIMenuItem(title: "Menu", action: "messageCopyTextAction:")]
            MenuController.setMenuVisible(true, animated: true)
            
            NSLog("showmenu")
            
        }
    }
    // 2. Copy text to pasteboard
    func messageCopyTextAction(menuController: UIMenuController) {
        //let selectedIndexPath = tableView.indexPathForSelectedRow()
        //let selectedMessage = chat.loadedMessages[selectedIndexPath!.section][selectedIndexPath!.row-1]
        //UIPasteboard.generalPasteboard().string = selectedMessage.text
    }
    
}