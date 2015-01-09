//
//  CommonHelper.swift
//  spot
//
//  Created by Hikaru on 2014/11/26.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation


class CommonHelper {
    //シングルトンパターン
    class var instance: CommonHelper {
        dispatch_once(&Inner.token) {
            Inner.instance = CommonHelper()
        }
        return Inner.instance!
    }
    private struct Inner {
        static var instance: CommonHelper?
        static var token: dispatch_once_t = 0
    }
    //初期化
    private init() {
    }
    
    
    
    //RGB To Color
    func UIColorFromRGB(rgbValue: UInt,alpha:CGFloat) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }

    //创建圆角按钮
    func createCircleButton(image:UIImage,origin:CGPoint,radius:CGFloat,background:UIColor,borderWidth:CGFloat,borderBackground:UIColor)->UIButton{
        var size = CGSize(width: radius*2,height: radius*2)
        var frame = CGRect()
        frame.origin = origin;
        frame.size = size;
        
        var view = UIButton(frame:frame)
        view.setImage(image, forState: .Normal)
        
        view.backgroundColor = background
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true;
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderBackground.CGColor
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowOffset = CGSizeMake(10, 10)
        return view
    }
    //重置控件大小
    func changeSize(view:UIView,size: CGSize){
        self.changeHeight(view, height: size.height)
        self.changeWidth(view, width: size.width)
        /*
        constraints = [
            //NSLayoutConstraint(item: view, attribute: .Left, relatedBy: .Equal, toItem: view.superview, attribute: .Left, multiplier: 1.0, constant: frame.origin.x), //x=10
            //NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: view.superview, attribute: .Top, multiplier: 1.0, constant: frame.origin.y), //y=10
            NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: size.width), //幅=100
            NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: size.height), //高さ=100
        ]
        view.addConstraints(constraints)
        */
        
    }
    //改变控件宽度
    func changeWidth(view:UIView,width: CGFloat){
        
        
        var constraints: NSArray = view.constraints()
        
        if(constraints.count > 0){
            constraints.indexOfObjectPassingTest { (var constraint, idx, stop) in
                if(constraint.firstAttribute == NSLayoutAttribute.Width){
                    view.removeConstraint(constraints[idx] as NSLayoutConstraint)
                    return true;
                }else{
                    return false
                }
            }
        }
        let constraint = NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: width);
        
        view.addConstraint(constraint)
    }
    //改变控件高度
    func changeHeight(view:UIView,height: CGFloat){
        
        var constraints: NSArray = view.constraints()
        if(constraints.count > 0){
            constraints.indexOfObjectPassingTest { (var constraint, idx, stop) in
                if(constraint.firstAttribute == NSLayoutAttribute.Height){
                    view.removeConstraint(constraints[idx] as NSLayoutConstraint)
                    return true;
                }else{
                    return false
                }
            }
        }
        let constraint = NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: height); //高さ
        
        view.addConstraint(constraint)
    }
    
    //异步设置图片
    func setImageFromUrl(imageview:UIImageView,uri:String,callback:(imgData:NSData)->()?){
        imageview.image =  UIImage(named: "noimage")
        
        if let image = UIImage(named: uri){
            imageview.image = image
            return
        }
        
        let cachekey = "cache_"+uri
        if let imgData = SettingHelper.instance.get(cachekey) as? NSData{
            imageview.image =  UIImage(data: imgData)
            return ;
        }
        let net = Net()
        net.GET(absoluteUrl: uri,
            params: nil,
            successHandler: { responseData in
                gcd.async(.Main) {
                    let result = responseData.data;
                    imageview.image =  UIImage(data: result)
                    SettingHelper.instance.set(cachekey, value: result)
                    callback(imgData: result)
                }
            },
            failureHandler: { error in
                imageview.image =  UIImage(named: "noimage")
            }
        )
    }
    
    //重绘纯色图片
    func coloredImage(image: UIImage, color:UIColor) -> UIImage! {
        let rect = CGRect(origin: CGPointZero, size: image.size)
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        image.drawInRect(rect)
        //CGContextSetRGBFillColor(context, red, green, blue, alpha)
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextSetBlendMode(context, kCGBlendModeSourceAtop)
        CGContextFillRect(context, rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    //文字内容高度
    func getFitHeight(maxWidth:CGFloat,text:String,fontSize:CGFloat)->CGFloat{
        
        
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, maxWidth, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = UIFont.systemFontOfSize(fontSize)
        label.text = text
        
        label.sizeToFit()
        
        return label.frame.height + 20

    }
}

/**
Determine whether Optional collection is nil or an empty collection

:param: collection Optional collection
:returns: true if collection is nil or if it is an empty collection, false otherwise
*/
public func isNilOrEmpty<C: CollectionType>(collection: C?) -> Bool {
    switch collection {
    case .Some(let nonNilCollection): return countElements(nonNilCollection) == 0
    default:                          return true
    }
}

/**
Determine whether Optional NSString is nil or an empty string

:param: string Optional NSString
:returns: true if string is nil or if it is an empty string, false otherwise
*/
public func isNilOrEmpty(string: NSString?) -> Bool {
    switch string {
    case .Some(let nonNilString): return nonNilString.length == 0
    default:                      return true
    }
}