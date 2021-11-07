//
//  ItemExtension.swift
//  TimeTo
//
//  Created by Hagemon on 2021/10/31.
//

import Foundation

extension Item {
    
    func getGap(now: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second], from: now, to: self.end ?? now)
        let finalComponents  = calendar.dateComponents([.second, .minute, .hour, .day], from: now, to: self.end ?? now)
        guard let seconds = components.second else {return ""}
        var unit: String
        var digit: Int = 0
        print(seconds, finalComponents)
        switch seconds {
        case _ where seconds < 60:
            unit = "秒"
            digit = seconds
        case _ where seconds < 3600:
            unit = "分钟"
            digit = finalComponents.minute ?? 0
        case _ where seconds < 3600 * 24:
            unit = "小时"
            digit = finalComponents.hour ?? 0
        default:
            unit = "天"
            digit = finalComponents.day ?? 0
        }
        return "\(digit)"+unit
    }
    
    func isExpired(now: Date) -> Bool {
        return now >= self.end ?? now
    }
    
    var isRecent: Bool {
        return (Date.now + 60 * 60 * 24 * 7) > self.end ?? Date.now
    }
    
    func setNotification() {
        var title: String
        let c = Category.inverse(rawValue: self.category ?? "cycle")
        if c == .cycle {
            title = "是时候更换\(self.name!)啦♻️"
        } else {
            title = "是时候\(self.name!)啦🏃‍♀️"
        }
        self.deleteNotification()
        NotifyTools.notify(title: title, identifier: self.objectID.description, date: self.end!)
    }
    
    func deleteNotification() {
        NotifyTools.removeNotification(identifier: self.objectID.description)
    }
}
