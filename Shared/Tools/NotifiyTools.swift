//
//  NotifiyTools.swift
//  TimeTo
//
//  Created by Hagemon on 2021/10/31.
//

import Foundation
import SwiftUI

class NotifyTools {
    static func notify(title: String, identifier: String, date: Date) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])  {
            success, _ in
            if success {
                print("authorization granted")
            }
        }
        let content = UNMutableNotificationContent()
        content.title = "TimeTo"
        content.body = title
        content.sound = .default
        var targetDate = date
        if targetDate.inValidDate() == .beforeStart {
            targetDate = targetDate.getTodayStart()
        } else if targetDate.inValidDate() == .afterEnd {
            targetDate = targetDate.getNextStart()
        }
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        print("set notification for \(identifier) at \(date)")
    }
    
    static func removeNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Delete notification for", identifier)
    }
    
    static func requestAuth() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])  {
            success, _ in
            if success {
                print("authorization granted")
            }
        }
    }
    
    static func simpleNotify() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])  {
            success, _ in
            if success {
                print("authorization granted")
            }
        }
        let content = UNMutableNotificationContent()
        content.title = "TimeTo"
        content.body = "你好👋"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "hagemon", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

}
