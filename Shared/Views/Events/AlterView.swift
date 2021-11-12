//
//  ItemManageView.swift
//  TimeTo
//
//  Created by Hagemon on 2021/10/30.
//

import SwiftUI
import Combine

struct AlterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        
    var category: Category
    @ObservedObject var item: Item
    @State private var showAlert: Bool = false
    
    @State private var notify: Bool = true
    @State private var name: String = "什么呢🤔"
    @State private var icon: String = "moon.stars"
    @State private var digit: Int = 1
    @State private var unit: TimeUnit = .hour
    @State private var start: Date = Date.now
    
    @State private var cycleNotify = true
    
    init(category: Category, item: Item) {
        self.item = item
        self.category = category
        _notify = State(initialValue: item.notify)
        _name = State(initialValue: item.name ?? "什么呢🤔️")
        _icon = State(initialValue: item.icon ?? "moon.stars")
        _digit = State(initialValue: Int(item.digit))
        _unit = State(initialValue: TimeUnit.inverse(rawValue: item.unit ?? "小时"))
        _start = State(initialValue: item.start ?? Date.now)
        _cycleNotify = State(initialValue: item.cycleNotify)
    }
    
    var body: some View {
        Form {
            Section(content: {
                BasicInfoForm(icon: $icon, name: $name, notify: $notify)
            }, header: {
                Text("基本信息")
            })
            Section(content: {
                
                if self.category == .cycle {
                    NavigationLink(destination: {
                        DatePickerView(date: $start)
                    }, label: {
                        HStack {
                            Text("开始时间")
                            Spacer()
                            Text("\(start.standard)")
                        }
                    })
                    NotifySettingForm(digit: $digit, unit: $unit)
                    HStack {
                        Text("提醒时间")
                        Spacer()
                        Text("\(start.forward(number: self.digit, unit: self.unit).standard)")
                            .foregroundColor(.secondary)
                    }
                } else {
                    Toggle("重复提醒", isOn: self.$cycleNotify)
                    NavigationLink(destination: {
                        DatePickerView(date: $start)
                    }, label: {
                        HStack {
                            Text("提醒时间")
                            Spacer()
                            Text("\(start.standard)")
                        }
                    })
                    if self.cycleNotify {
                        NotifySettingForm(digit: $digit, unit: $unit)
                    }
                }
            }, header: {
                Text("提醒设置")
            })            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(category == .cycle ? "修改周期" : "修改定时")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    self.updateItem()
                }, label: {
                    Text("保存")
                })
                    .alert("同步失败，再点一下保存哦☁️", isPresented: $showAlert, actions: {
                        Button(action: {}, label: {
                            Text("OK")
                        })
                    })
            })
        }
        
        
    }
    
    func updateItem() {
        viewContext.performAndWait {
            self.item.start = self.start
            self.item.icon = self.icon
            self.item.name = self.name
            self.item.category = self.category.rawValue
            self.item.notify = self.notify
            self.item.digit = Int64(self.digit)
            self.item.unit = self.unit.rawValue
            self.item.cycleNotify = self.cycleNotify
            if self.category == .cycle {
                self.item.end = item.start!.forward(
                    number: Int(item.digit),
                    unit: TimeUnit.inverse(rawValue: item.unit!)
                )
            } else {
                self.item.end = self.start
            }
            
            if self.notify {
                item.setNotification()
            } else {
                item.deleteNotification()
            }
            do {
                try viewContext.save()
                self.presentationMode.wrappedValue.dismiss()
            } catch {
                let nsError = error as NSError
                self.showAlert.toggle()
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct AlterView_Previews: PreviewProvider {
    @State static var value = false
    @StateObject static var item = Factory.itemFactory(viewContext: PersistenceController.preview.container.viewContext)
    static var previews: some View {
        NavigationView {
            AlterView(category: .cycle, item: item)
                .preferredColorScheme(.dark)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
