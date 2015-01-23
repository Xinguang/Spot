//
//  UserModel.swift
//  spot
//
//  Created by Hikaru on 2014/12/25.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation

class UserModel {
    let ID: Int
    var nickname: String?
    var birthday: String?
    var figure:String?
    var age: NSInteger? {
        if birthday != nil {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.dateFromString(birthday!)
            
            var userAge : NSInteger = 0
            var calendar : NSCalendar = NSCalendar.currentCalendar()
            var unitFlags : NSCalendarUnit = NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay
            var dateComponentNow : NSDateComponents = calendar.components(unitFlags, fromDate: NSDate())
            var dateComponentBirth : NSDateComponents = calendar.components(unitFlags, fromDate: date!)
            
            if ( (dateComponentNow.month < dateComponentBirth.month) ||
                ((dateComponentNow.month == dateComponentBirth.month) && (dateComponentNow.day < dateComponentBirth.day))
                )
            {
                return dateComponentNow.year - dateComponentBirth.year - 1
            }
            else {
                return dateComponentNow.year - dateComponentBirth.year
            }
            
        } else {
            return 0
        }
    }
    
    init(ID: Int) {
        self.ID = ID
    }
    
    convenience init(ID: Int, nickname: String, birthday: String,figure:String) {
        self.init(ID: ID)
        self.nickname = nickname
        self.birthday = birthday
    }
}