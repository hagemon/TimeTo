//
//  UserDefaulsExtension.swift
//  TimeTo
//
//  Created by Hagemon on 2021/11/2.
//

import Foundation
import SwiftUI

extension UserDefaults {
    func valueExists(key: String) -> Bool {
        return object(forKey: key) != nil
    }
    
    func getGlobalStart() -> Date {
        if valueExists(key: "global_start") {
            return Date.clock(at: integer(forKey: "global_start"))
        } else {
            return Date.clock(at: 8)
        }
    }
    
    func getGlobalEnd() -> Date {
        if valueExists(key: "global_end") {
            return Date.clock(at: integer(forKey: "global_end"))
        } else {
            return Date.clock(at: 22)
        }
    }
    
    func getSchema() -> ColorScheme? {
        if !valueExists(key: "schema") {
            return .none
        }
        switch string(forKey: "schema") {
        case "none":
            return .none
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return .none
        }
    }
    
    func setSchema(schema: ColorScheme?) {
        var key: String
        switch schema {
        case .dark:
            key = "dark"
        case .light:
            key = "light"
        default:
            key = "none"
        }
        set(key, forKey: "schema")
    }
}
