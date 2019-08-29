//
//  DateExtension.swift
//  newsApp
//
//  Created by Ruslan Latfulin on 8/29/19.
//  Copyright © 2019 Ruslan Latfulin. All rights reserved.
//

import Foundation

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    static var weekAgo: Date { return Date().weekAgo }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var weekAgo: Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: -1, to: noon)!
    }
    
    func getString() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: self)
        return formattedDate
    }
}
