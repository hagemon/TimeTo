//
//  TimeListView.swift
//  TimeTo
//
//  Created by Hagemon on 2021/10/28.
//

import SwiftUI

struct TimeListView: View {
    
    var title: String
    var category: Category
    
    @Environment(\.presentationMode) var presentation
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.end, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var showAddView: Bool = false
    @State private var showAlert: Bool = false
    @State private var refreshTime: Date = Date.now
    
    var shownItems: [Item] {
        return items.filter({ item in
            item.category == category.rawValue
        })
    }
    
    var recentItems: [Item] {
        return shownItems.filter({ item in
            item.isRecent
        })
    }
    
    var remoteItems: [Item] {
        return shownItems.filter({ item in
            !item.isRecent
        })
    }
    
    var body: some View {
        NavigationView {
            List {
                if shownItems.count > 0 {
                    if recentItems.count > 0 {
                        Section("一周内", content: {
                            ForEach(recentItems.filter({ item in
                                return item.isExpired(now: refreshTime)
                            }), id: \.objectID) { item in
                                ItemRow(item: item, date: $refreshTime)
                                    .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                                        Button(action: {
                                            self.refreshItem(item: item)
                                        }, label: {
                                            Label("Finish", systemImage: "checkmark")
                                        })
                                            .tint(.green)
                                    })
                            }
                            
                            ForEach(recentItems.filter({ item in
                                return !item.isExpired(now: refreshTime)
                            }), id: \.objectID) { item in
                                if !item.isExpired(now: refreshTime) {
                                    NavigationLink(destination: AlterView(
                                        category: category,
                                        item: item, refreshTime: $refreshTime
                                    ).environment(\.managedObjectContext, viewContext)) {
                                        ItemRow(item: item, date: $refreshTime)
                                    }
                                }
                            }
                            .onDelete {
                                self.deleteItem(at: $0, in: 0)
                            }
                        })
                    }
                    if remoteItems.count > 0 {
                        Section("一周后", content: {
                            ForEach(remoteItems, id: \.objectID) { item in
                                NavigationLink(destination: AlterView(
                                    category: category,
                                    item: item, refreshTime: $refreshTime
                                ).environment(\.managedObjectContext, viewContext)) {
                                    ItemRow(item: item, date: $refreshTime)
                                }
                            }
                            .onDelete {
                                self.deleteItem(at: $0, in: 1)
                            }

                        })
                    }
                } else {
                    Section {
                        HStack {
                            Spacer()
                            Image("stars_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 300)
                            Spacer()
                        }.listRowBackground(Color.clear)
                        
                    }
                    HStack {
                        Spacer()
                        Text("点击右上角，添加一个提醒吧！")
                        Spacer()
                    }.padding()
                }
                
            }
            .refreshable {
                refreshTime = Date.now
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        showAddView.toggle()
//
//                    }) {
//                        Label("Add Item", systemImage: "plus")
//                    }
                    NavigationLink(destination: {
                        AddView(show: self.$showAddView, refreshTime: $refreshTime, category: category)
                    }, label: {
                        Label("Add Item", systemImage: "plus")
                    })
                }
            }
            .navigationTitle(self.title)
//            .sheet(isPresented: $showAddView, onDismiss: {}, content: {
//                AddView(
//                    show: $showAddView,
//                    category: category
//                )
//            })
        }
        .navigationViewStyle(.stack)
        .onAppear(perform: {
            refreshTime = Date.now
            print("refresh time update:", refreshTime)
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            refreshTime = Date.now
            print("refresh time update:", refreshTime)
        }
    }
    
    private func deleteItem(at offsets: IndexSet, in section: Int) {
        offsets.map {
            self.shownItems[$0+section*self.recentItems.count]
        }.forEach({
            item in
            item.deleteNotification()
            viewContext.delete(item)
        })
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func refreshItem(item: Item) {
        let category = Category(rawValue: item.category!) ?? .cycle
        let now = Date.now
        if category == .cycle {
            item.end = now.forward(number: Int(item.digit), unit: TimeUnit.inverse(rawValue: item.unit!))
            item.start = now
            item.setNotification()
        } else {
            if item.cycleNotify {
                let nextEnd = item.getNextEnd()
                item.start = nextEnd
                item.end = nextEnd
                item.setNotification()
            } else {
                item.deleteNotification()
                viewContext.delete(item)
            }
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func deleteAll() {
        items.forEach({
            item in
            item.deleteNotification()
            viewContext.delete(item)
        })
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
}

struct TimeListView_Previews: PreviewProvider {
    static var previews: some View {
        TimeListView(title: "日常更换", category: .daily).preferredColorScheme(.dark).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.portraitUpsideDown)
        TimeListView(title: "日常更换", category: .cycle).preferredColorScheme(.dark).previewInterfaceOrientation(.landscapeRight)
    }
}
