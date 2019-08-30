//
//  StringExtension.swift
//  newsApp
//
//  Created by Ruslan Latfulin on 8/29/19.
//  Copyright © 2019 Ruslan Latfulin. All rights reserved.
//

import Foundation

extension String {
    func getDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let currDate = dateFormatter.date(from: self)!
        return currDate
    }
}
