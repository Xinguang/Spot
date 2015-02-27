//
//  StringExtension.swift
//  spot
//
//  Created by Hikaru on 2015/02/25.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import Foundation
public extension String {
    func replace(pattern: String, template: String) -> String {
        if self =~ pattern {
            let range: NSRange = NSMakeRange(0, countElements(self))
            if let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(0), error: nil){
                return regex.stringByReplacingMatchesInString(self, options: NSMatchingOptions(0), range: range, withTemplate: template)
            }
        }
        return self;
    }
}