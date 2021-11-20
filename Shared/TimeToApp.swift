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
    @State var showIntro = UserDefaults.standard.isFirstLogin()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                TimeListView(title: "Cycle".localized, category: .cycle)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Label("Cycle", systemImage: "leaf.fill")
                    }
                    
                TimeListView(title: "Schedule".localized, category: .daily)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem{
                        Label("Schedule", systemImage: "figure.walk")
                    }
                SettingsView(schema: $colorSchema)
                    .tabItem {
                        Label("Settings", systemImage: "slider.vertical.3")
                    }
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
            .preferredColorScheme(colorSchema)
//            .onAppear(perform: {
//                UITableView.appearance().backgroundColor = nil
//                UIPageControl.appearance().currentPageIndicatorTintColor = nil
//                UIPageControl.appearance().pageIndicatorTintColor = nil
//            })
            .fullScreenCover(isPresented: $showIntro, onDismiss: {}, content: {
                IntroductionView(show: $showIntro)
            })
        }
    }
}
