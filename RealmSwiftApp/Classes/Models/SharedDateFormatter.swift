//
//  SharedDateFormatter.swift
//  UserNotificationSwift3
//
//  Created by Roman Rybachenko on 11/24/16.
//  Copyright © 2016 Roman Rybachenko. All rights reserved.
//

import Foundation

let birthdayDateFormat = "dd MMMM, yyyy"

class SharedDateFormatter: DateFormatter {
    
    static let dateFormatter: SharedDateFormatter = {
        let instance = SharedDateFormatter()
//        instance.locale = Locale(identifier: "en_GB")
        instance.timeZone = NSTimeZone.local
        
        return instance
    }()
    
    private override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Public func
    
    func dateFromString(string: String, format: String) -> Date? {
        self.dateFormat = format
        let date = self.date(from: string)
        return date
    }
    
    func stringFromDate(date: Date, format: String) -> String? {
        self.dateFormat = format
        let dateStr = self.string(from: date)
        return dateStr
    }
}
