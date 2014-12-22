//
//  EventTabController.swift
//  spot
//
//  Created by Hikaru on 2014/12/05.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit
class EventTabController:CommonTabController{
    var _menu:REMenu = REMenu()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //"参加", "★", "投稿", "チャット"
        self._menu = REMenu(items: [
            CustomRemenuItem(title: "参加",subtitle: "subTitle",image: nil,highlightedImage: nil,{ (item) -> Void in
                return;
            }),
            CustomRemenuItem(title: "★",subtitle: "subTitle",image: nil,highlightedImage: nil,{ (item) -> Void in
                return;
            }),
            CustomRemenuItem(title: "投稿",subtitle: "subTitle",image: nil,highlightedImage: nil,{ (item) -> Void in
                self.performSegueWithIdentifier("bbs_post",sender: "イベント")
            }),
            CustomRemenuItem(title: "チャット",subtitle: "subTitle",image: nil,highlightedImage: nil,{ (item) -> Void in
                self.performSegueWithIdentifier("pop_message",sender: "イベント")
            })
            
            ])
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...", style: .Plain, target: self, action: Selector("toggleMenu"))
        

    }
    
    func toggleMenu()
    {
        if (self._menu.isOpen){
            return self._menu.close()
        }
        //self._menu.showFromNavigationController(self.navigationController)
        self._menu.showFromRect(CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height), inView: self.view)
    }
}