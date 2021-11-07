//
//  Persistence.swift
//  Shared
//
//  Created by Hagemon on 2021/10/29.
//

import CoreData

let demo_item: Item = {
    let newItem = Item(context: PersistenceController.shared.container.viewContext)
    let now = Date.now
    newItem.timestamp = now
    newItem.start = now
    newItem.end = now.forward(number: 30, unit: .day)
    newItem.icon = "hands.sparkles.fill"
    newItem.name = "Some"
    newItem.category = "daily"
    newItem.notify = false
    newItem.digit = 30
    newItem.unit = "天"
    newItem.cycleNotify = true
    newItem.cycleString = "30天"
    return newItem
}()

let experied_item: Item = {
    let newItem = Item(context: PersistenceController.shared.container.viewContext)
    let now = Date.now
    newItem.timestamp = now
    newItem.start = now
    newItem.end = now.forward(number: -30, unit: .day)
    newItem.icon = "hands.sparkles.fill"
    newItem.name = "Some"
    newItem.category = "daily"
    newItem.notify = false
    newItem.digit = 30
    newItem.unit = "天"
    newItem.cycleNotify = true
    newItem.cycleString = "30天"
    return newItem
}()

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<5 {
            let newItem = Item(context: viewContext)
            let now = Date.now
            newItem.timestamp = now
            newItem.start = now
            if i == 0 {
                newItem.end = now.forward(number: -1, unit: .day)
            } else {
                newItem.end = now.forward(number: 30, unit: .day)
            }
            newItem.icon = "hands.sparkles.fill"
            newItem.name = "Some"
            newItem.category = "daily"
            newItem.notify = false
            newItem.digit = 30
            newItem.unit = "天"
            newItem.cycleNotify = true
            newItem.cycleString = "30天"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "TimeTo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
