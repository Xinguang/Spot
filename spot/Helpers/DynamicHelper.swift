//
//  DynamicHelper.swift
//  spot
//
//  Created by Hikaru on 2014/12/16.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation
class DynamicHelper:NSObject {
    
    var theAnimators:[Int:UIDynamicAnimator] = [:];
    
    //シングルトンパターン
    class var instance: DynamicHelper {
        dispatch_once(&Inner.token) {
            Inner.instance = DynamicHelper()
        }
        return Inner.instance!
    }
    private struct Inner {
        static var instance: DynamicHelper?
        static var token: dispatch_once_t = 0
    }
    //初期化
    private override init() {
    }
    //重力加依附
    func gravityAttachment(view:UIView,length:CGFloat){
        var theAnimator = UIDynamicAnimator(referenceView:view.superview!);
        self.theAnimators[view.hash] = theAnimator;
        
        let gravityBehaviour = UIGravityBehavior(items: [view]);
        theAnimator.addBehavior(gravityBehaviour);
        var attachmentBehavior = UIAttachmentBehavior(item: view,attachedToAnchor:view.center)
        attachmentBehavior.length = length
        attachmentBehavior.damping = 0.1
        attachmentBehavior.frequency = 5
        theAnimator.addBehavior(attachmentBehavior);

        
    }
}