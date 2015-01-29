//
//  TextViewAutoHeight.swift
//  spot
//
//  Created by Hikaru on 2015/01/28.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import UIKit

protocol TextViewAutoHeightDelegate{
    func heightChanged(height:CGFloat)
}
class TextViewAutoHeight: UITextView {
    
    //MARK: attributes
    
    var maxHeight:CGFloat?
    var heightDelegate:TextViewAutoHeightDelegate?
    
    private var originalHeight:CGFloat = 0
    private var heightConstraint:NSLayoutConstraint?
    
    //MARK: initialize
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpInit()
    }
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUpInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fixTextViewHeigth(self.getFinalContentSize())
    }
    
    //MARK: private
    
    private func setUpInit() {
        self.textContainerInset = UIEdgeInsetsMake(0,0,5,0)
        for constraint in self.constraints() {
            if constraint.firstAttribute == NSLayoutAttribute.Height {
                self.heightConstraint = constraint as? NSLayoutConstraint;
                break;
            }
        }
        
    }
    private func getFinalContentSize()->CGSize{
        var finalContentSize:CGSize = self.contentSize
        finalContentSize.width  += (self.textContainerInset.left + self.textContainerInset.right ) / 2.0
        finalContentSize.height += (self.textContainerInset.top  + self.textContainerInset.bottom) / 2.0
        return finalContentSize;
    }
    
    private func fixTextViewHeigth(finalContentSize:CGSize) {
        if let maxHeight = self.maxHeight {
            var  customContentSize = finalContentSize;
            customContentSize.height = max(CGFloat(self.originalHeight),min(customContentSize.height, CGFloat(maxHeight)))
            if(self.originalHeight == 0){
                self.originalHeight = customContentSize.height
            }
            self.heightDelegate?.heightChanged(customContentSize.height - self.originalHeight)
            if let heightConstant = self.heightConstraint?.constant {
                self.heightConstraint?.constant = customContentSize.height;
            }else{
                self.frame.size.height = customContentSize.height;
            }
            
            if finalContentSize.height <= CGRectGetHeight(self.frame) {
                let textViewHeight = (CGRectGetHeight(self.frame) - self.contentSize.height * self.zoomScale)/2.0
                
                self.contentOffset = CGPointMake(0, -(textViewHeight < 0.0 ? 0.0 : textViewHeight))
                
            }
            
        }
    }
}