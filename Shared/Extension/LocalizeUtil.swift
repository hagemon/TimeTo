//
//  LocalizeUtil.swift
//  TimeTo
//
//  Created by Hagemon on 2021/11/20.
//

import Foundation

class LocalizeUtil {
    static var lan: String {
        return Locale.current.languageCode ?? "zh-Hans"
    }
    
    static var unitDict: [String:String] {
        return ["分钟": "Minute", "小时": "Hour", "天": "Day", "月": "Month", "秒": "Second"]
    }
    
    static var isZH: Bool {
        return self.lan.lowercased().starts(with: "zh")
    }
    
    static func getLocalizedUnit(unit: String) -> String {
        if self.isZH {
            return unit
        }
        return self.unitDict[unit] ?? "Error"
    }
    
    static func localizedString(string: String) -> String {
        return NSLocalizedString(string, comment: "")
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
