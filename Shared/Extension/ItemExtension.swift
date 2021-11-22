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
        var result = "\(digit) "+LocalizeUtil.getLocalizedUnit(unit: unit)
        if digit > 1 && !LocalizeUtil.isZH {
            result += "s"
        }
        return result
    }
    
    func isExpired(now: Date) -> Bool {
        return now >= self.end ?? now
    }
    
    var isRecent: Bool {
        return (Date.now + 60 * 60 * 24 * 7) > self.end ?? Date.now
    }
    
    var localizedUnit: String {
        guard let unit = self.unit else {return ""}
        return LocalizeUtil.getLocalizedUnit(unit: unit)
    }
    
    func getNextEnd() -> Date {
        let now = Date.now
        guard var currentEnd = self.end else { return now }
        while currentEnd < now {
            currentEnd = currentEnd.forward(number: Int(self.digit), unit: TimeUnit.inverse(rawValue: self.unit!))
        }
        return currentEnd
    }
    
    var itemId: String {
        guard let stamp = self.timestamp else {return "invalid"}
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: stamp)
    }
    
    func setNotification() {
        var title: String
        let c = Category.inverse(rawValue: self.category ?? "cycle")
        if c == .cycle {
            title = "Cycle Notification \(self.name!)".localized
        } else {
            title = "Daily Notification \(self.name!)".localized
        }
        self.deleteNotification()
        NotifyTools.notify(title: title, identifier: self.itemId, date: self.end!)
    }
    
    func deleteNotification() {
        NotifyTools.removeNotification(identifier: self.itemId)
    }
}
