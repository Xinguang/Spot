//
//  ExtensionArray.swift
//  spot
//
//  Created by Hikaru on 2015/01/07.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

extension String {
    func replace(pattern: String, template: String) -> String {
        if self =~ pattern {
            let range: NSRange = NSMakeRange(0, countElements(self))
            if let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(0), error: nil){
                return regex.stringByReplacingMatchesInString(self, options: NSMatchingOptions(0), range: range, withTemplate: template)
            }
        }
        return self;
    }
    func match(pattern: String) -> [String] {
        var matches : Array<String> = Array<String>()
        if let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(0), error: nil){
            let nsstr = self as NSString
            let range: NSRange = NSMakeRange(0, countElements(self))
            regex.enumerateMatchesInString(self, options: NSMatchingOptions(0), range: range) {
                (result : NSTextCheckingResult!, flags : NSMatchingFlags, ptr : UnsafeMutablePointer<ObjCBool>) in
                let string = nsstr.substringWithRange(result.range)
                matches.append(string)
            }
        }
        return matches
    }
}

infix operator =~ {} //mach all

func =~ (value : String, pattern : String) -> Bool {
    return value.match(pattern).count > 0
}
/*

if "Hello World" =~ "\\w+" {
    println("matched")
}

for m in "Hello World".match("\\w+") {
    println("matched \(m)")
}

println("Hello World".replace("(\\w+\\s*)(\\w+)", template: "$0  $1  $2"))
*/