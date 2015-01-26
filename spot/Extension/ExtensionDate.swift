//
//  ExtensionDate.swift
//  spot
//
//  Created by Hikaru on 2015/01/26.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

enum DateFormat {
    case ISO8601, DotNet, RSS, AltRSS
    case Custom(String)
}

extension NSDate {
    func toString(format: DateFormat) -> String
    {
        var dateFormat: String
        switch format {
        case .DotNet:
            let offset = NSTimeZone.defaultTimeZone().secondsFromGMT / 3600
            let nowMillis = 1000 * self.timeIntervalSince1970
            return  "/Date(\(nowMillis)\(offset))/"
        case .ISO8601:
            dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        case .RSS:
            dateFormat = "EEE, d MMM yyyy HH:mm:ss ZZZ"
        case .AltRSS:
            dateFormat = "d MMM yyyy HH:mm:ss ZZZ"
        case .Custom(let string):
            dateFormat = string
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.stringFromDate(self)
    }
    
}