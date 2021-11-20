//
//  AddView.swift
//  TimeTo
//
//  Created by Hagemon on 2021/10/29.
//

import SwiftUI
import Combine

struct AddView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentation
    
    @Binding var show: Bool
    @Binding var refreshTime: Date

    var category: Category
    
    @State private var notify: Bool = true
    @State private var name: String = "什么呢🤔"
    @State private var icon: String = "moon.stars"
    @State private var digit: Int = 1
    @State private var unit: TimeUnit = .hour
    @State private var start: Date = Date.now
    
    @State private var cycleNotify = true
    @State private var dateChosen = false
    
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
                            .onChange(of: start, perform: { newValue in
                                dateChosen = true
                            })
                    }, label: {
                        HStack {
                            Text("提醒时间")
                            Spacer()
                            if self.dateChosen {
                                Text("\(start.standard)")
                            } else {
                                Text("\(start.forward(number: self.digit, unit: self.unit).standard)")
                            }
                            
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
        .navigationTitle(category == .cycle ? "新增周期" : "新增定时")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    self.show = false
                    self.addItem()
                }, label: {
                    Text("完成")
                })
            })
        }
    }
    
    func addItem() {
        let newItem = Item(context: viewContext)
        newItem.timestamp = Date.now
        newItem.start = self.start
        if self.category == .cycle {
            newItem.end = self.start.forward(number: self.digit, unit: self.unit)
        } else {
            if dateChosen {
                newItem.end = self.start
            } else {
                newItem.end = self.start.forward(number: self.digit, unit: self.unit)
            }
        }
        newItem.icon = self.icon
        newItem.name = self.name
        newItem.category = self.category.rawValue
        newItem.notify = self.notify
        newItem.digit = Int64(self.digit)
        newItem.unit = self.unit.rawValue
        newItem.cycleNotify = self.cycleNotify
        if self.notify {
            newItem.setNotification()
        }
        do {
            self.refreshTime = Date.now
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        presentation.wrappedValue.dismiss()
    }
    
}

struct AddView_Previews: PreviewProvider {
    @State static var value = false
    @State static var date = Date.now
    static var previews: some View {
        NavigationView {
            AddView(show: $value, refreshTime: $date, category: .cycle)
                .preferredColorScheme(.light)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
        NavigationView {
            AddView(show: $value, refreshTime: $date, category: .daily)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
