//
//  Factory.swift
//  TimeTo
//
//  Created by Hagemon on 2021/10/30.
//

import Foundation
import CoreData

class Factory {
    static func itemFactory(viewContext: NSManagedObjectContext) -> Item {
        let newItem = Item(context: viewContext)
        newItem.start = Date.now.forward(number: -10, unit: .day)
        newItem.end = newItem.start!.forward(number: 24, unit: .day)
        newItem.icon = "moon.stars"
        newItem.name = "工厂出品🏭"
        newItem.notify = true
        newItem.digit = 24
        newItem.unit = "天"
        return newItem
    }
}
