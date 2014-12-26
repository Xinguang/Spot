//
//  CellChat.swift
//  spot
//
//  Created by Hikaru on 2014/12/26.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//
import UIKit

let incomingTag = 0, outgoingTag = 1
let bubbleTag = 8
let messageFontSize: CGFloat = 17

class CellChat: UITableViewCell {
    let bubbleImageView: UIImageView
    let messageLabel: UILabel
    let userIcon: UIImageView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        bubbleImageView = UIImageView(image: bubbleImage.incoming, highlightedImage: bubbleImage.incomingHighlighed)
        bubbleImageView.tag = 50
        bubbleImageView.userInteractionEnabled = true // #CopyMesage
        
        messageLabel = UILabel(frame: CGRectZero)
        messageLabel.font = UIFont.systemFontOfSize(messageFontSize)
        messageLabel.numberOfLines = 0
        messageLabel.userInteractionEnabled = false   // #CopyMessage
        
        userIcon = UIImageView(image: UIImage(named: "noimage"))
        userIcon.contentMode = UIViewContentMode.ScaleAspectFit;
        userIcon.layer.cornerRadius = 5
        userIcon.layer.masksToBounds = true;
        userIcon.tag = 5
        userIcon.userInteractionEnabled = true // #CopyMesage
        
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        contentView.addSubview(userIcon)
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageLabel)
        
        bubbleImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        messageLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        userIcon.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: userIcon, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 5))
        contentView.addConstraint(NSLayoutConstraint(item: userIcon, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 2))
        
        CommonHelper.instance.changeSize(userIcon, size: CGSizeMake(40, 40))
        //userIcon.addConstraint(NSLayoutConstraint(item: userIcon, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40))
        //userIcon.addConstraint(NSLayoutConstraint(item: userIcon, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40))
        
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 50))
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 2))
        bubbleImageView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Width, relatedBy: .Equal, toItem: messageLabel, attribute: .Width, multiplier: 1, constant: 30))
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -2))
        
        bubbleImageView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .CenterX, relatedBy: .Equal, toItem: bubbleImageView, attribute: .CenterX, multiplier: 1, constant: 3))
        bubbleImageView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .CenterY, relatedBy: .Equal, toItem: bubbleImageView, attribute: .CenterY, multiplier: 1, constant: -0.5))
        messageLabel.preferredMaxLayoutWidth = contentView.bounds.size.width - 100
        bubbleImageView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .Height, relatedBy: .Equal, toItem: bubbleImageView, attribute: .Height, multiplier: 1, constant: -15))
        
        
        //GestureRecognizerHelper.instance.LabelLongPress(bubbleImageView)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithMessage(isLeft:Bool,imageUrl:String,message: String) {
        if let image = UIImage(named: imageUrl){
            userIcon.image = image
        }else{
            CommonHelper.instance.setImageFromUrl(userIcon, uri: imageUrl, callback: { (imgData) -> () in
                
            })
        }
        userIcon.frame = CGRectMake(0,0, 40, 40);
        messageLabel.text = message
        if isLeft != (tag == incomingTag) {
            if isLeft {
                tag = incomingTag
                bubbleImageView.image = bubbleImage.incoming
                bubbleImageView.highlightedImage = bubbleImage.incomingHighlighed
                messageLabel.textColor = UIColor.blackColor()
            } else { // outgoing
                tag = outgoingTag
                bubbleImageView.image = bubbleImage.outgoing
                bubbleImageView.highlightedImage = bubbleImage.outgoingHighlighed
                messageLabel.textColor = UIColor.blackColor()
            }
            
            let layoutConstraint: NSLayoutConstraint = bubbleImageView.constraints()[1] as NSLayoutConstraint // `messageLabel` CenterX
            layoutConstraint.constant = -layoutConstraint.constant
        }
        self.resetLayer([userIcon,bubbleImageView], isLeft: isLeft)
    }
    
    // Highlight cell #CopyMessage
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        bubbleImageView.highlighted = selected
    }
    func resetLayer(items:[UIView] ,isLeft:Bool){
        
        var layoutAttribute: NSLayoutAttribute
        
        
        var layoutConstant: CGFloat
        
        if isLeft {
            layoutAttribute = .Left
            layoutConstant = 1
        } else {
            layoutAttribute = .Right
            layoutConstant = -1
        }
        
        for item in items{
            let constraints: NSArray = contentView.constraints()
            let indexOfConstraint = constraints.indexOfObjectPassingTest { (var constraint, idx, stop) in
                return (constraint.firstItem as UIView).tag == item.tag && (constraint.firstAttribute == NSLayoutAttribute.Left || constraint.firstAttribute == NSLayoutAttribute.Right)
            }
            contentView.removeConstraint(constraints[indexOfConstraint] as NSLayoutConstraint)
            contentView.addConstraint(NSLayoutConstraint(item: item, attribute: layoutAttribute, relatedBy: .Equal, toItem: contentView, attribute: layoutAttribute, multiplier: 1, constant: layoutConstant*CGFloat(item.tag)))
        }
    }
    
    
    
    
}

let bubbleImage = bubbleImageMake()

func bubbleImageMake() -> (incoming: UIImage, incomingHighlighed: UIImage, outgoing: UIImage, outgoingHighlighed: UIImage) {
    let maskOutgoing = UIImage(named: "chat")!
    let maskIncoming = UIImage(CGImage: maskOutgoing.CGImage, scale: 2, orientation: .UpMirrored)!
    
    let capInsetsIncoming = UIEdgeInsets(top: 17, left: 26.5, bottom: 17.5, right: 21)
    let capInsetsOutgoing = UIEdgeInsets(top: 17, left: 21, bottom: 17.5, right: 26.5)
    
    let incoming = CommonHelper.instance.coloredImage(maskIncoming, color:
        CommonHelper.instance.UIColorFromRGB(0xE3E3E3, alpha: 0.75)
        ).resizableImageWithCapInsets(capInsetsIncoming)
    let incomingHighlighted = CommonHelper.instance.coloredImage(maskIncoming, color:
        CommonHelper.instance.UIColorFromRGB(0xCACCCB, alpha: 0.75)
        ).resizableImageWithCapInsets(capInsetsIncoming)
    let outgoing = CommonHelper.instance.coloredImage(maskOutgoing, color:
        CommonHelper.instance.UIColorFromRGB(0x2FED89, alpha: 0.75)
        ).resizableImageWithCapInsets(capInsetsOutgoing)
    let outgoingHighlighted = CommonHelper.instance.coloredImage(maskOutgoing, color:
        CommonHelper.instance.UIColorFromRGB(0x3EB877, alpha: 0.75)
        ).resizableImageWithCapInsets(capInsetsOutgoing)
    
    return (incoming, incomingHighlighted, outgoing, outgoingHighlighted)
}