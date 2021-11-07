//
//  TimeToApp.swift
//  Shared
//
//  Created by Hagemon on 2021/10/29.
//

import SwiftUI

@main
struct TimeToApp: App {
    let persistenceController = PersistenceController.shared
    @State var colorSchema: ColorScheme? = UserDefaults.standard.getSchema()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                TimeListView(title: "日常更换", category: .cycle)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Label("日常更换", systemImage: "leaf.fill")
                    }
                TimeListView(title: "定时提醒", category: .daily)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem{
                        Label("定时提醒", systemImage: "figure.walk")
                    }
                SettingsView(schema: $colorSchema)
                    .tabItem {
                        Label("设置", systemImage: "slider.vertical.3")
                    }
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
            .preferredColorScheme(colorSchema)
        }
    }
}
