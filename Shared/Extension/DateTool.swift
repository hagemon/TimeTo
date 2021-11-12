//
//  DateTool.swift
//  TimeTo
//
//  Created by Hagemon on 2021/10/28.
//

import Foundation

extension Date {
    var standard: String {
        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: self)
    }
    
    static func clock(at clock:Int, minute:Int=0, second:Int=0) -> Date{
        return Calendar.current.date(bySettingHour: clock, minute: minute, second: second, of: Date.now)!
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    func getTodayStart() -> Date {
        let start = UserDefaults.standard.getGlobalStart()
        return Calendar.current.date(bySettingHour: start.hour, minute: start.minute, second: 0, of: self)!
    }
    
    func getNextStart() -> Date {
        return getTodayStart().forward(number: 1, unit: .day)
    }
    
    func inValidDate() -> DateInvalidType {
        let start = UserDefaults.standard.getGlobalStart().hour
        let end = UserDefaults.standard.getGlobalEnd().hour
        if self.hour > start && self.hour < end {
            return .none
        } else if self.hour < start {
            return .beforeStart
        } else {
            return .afterEnd
        }
    }
    
    func forward(number: Int, unit: TimeUnit) -> Date {
        var comp: Calendar.Component
        switch unit {
        case .minute:
            comp = .minute
        case .hour:
            comp = .hour
        case .day:
            comp = .day
        case .month:
            comp = .month
        }
        let date = Calendar.current.date(byAdding: comp, value: number, to: self) ?? self
        let c = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return Calendar.current.date(from: c) ?? self
    }
    
}
