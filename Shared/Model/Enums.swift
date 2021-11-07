//
//  Enums.swift
//  TimeTo
//
//  Created by Hagemon on 2021/10/30.
//

import Foundation

enum Category: String {
    case cycle = "cycle"
    case daily = "daily"
    
    static func inverse(rawValue: String) -> Category {
        let category = Category(rawValue: rawValue)
        return category ?? .cycle
    }
    
}

enum TimeUnit: String, CaseIterable {
    case minute = "分钟"
    case hour = "小时"
    case day = "天"
    case month = "月"
    
    static func inverse(rawValue: String) -> TimeUnit {
        let unit = TimeUnit(rawValue: rawValue)
        return unit ?? .hour
    }
    
    static var allRawValue: [String] {
        return allCases.map({
            $0.rawValue
        })
    }
    
}

enum DateInvalidType {
    case beforeStart
    case afterEnd
    case none
}
