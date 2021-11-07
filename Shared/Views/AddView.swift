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
    
    var category: Category
    
    @State private var notify: Bool = true
    @State private var name: String = "什么呢🤔"
    @State private var icon: String = "moon.stars"
    @State private var digit: Int = 1
    @State private var unit: TimeUnit = .hour
    @State private var start: Date = Date.now
    
    @State private var cycleNotify = true
    
    var body: some View {
        Form {
            Section(content: {
                NavigationLink(destination: {
                    GallaryView(icon: $icon)
                }, label: {
                    Text("图标")
                    Spacer()
                    Image(systemName: icon)
                })
                HStack {
                    Text("名称")
                    TextField("", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                Toggle("开启提醒", isOn: $notify)
            }, header: {
                Text("基本信息")
            })
            
            Section(content: {
                Toggle("周期性提醒", isOn: self.$cycleNotify)
                NavigationLink(destination: {
                    DatePickerView(date: $start)
                }, label: {
                    HStack {
                        Text((self.cycleNotify ? "开始" : "提醒") + "时间")
                        Spacer()
                        Text("\(start.standard)")
                    }
                })
                if self.cycleNotify {
                    HStack {
                        TextField("", value: $digit, format: .number)
                            .multilineTextAlignment(.leading)
                            .keyboardType(.numberPad)
                            .onReceive(Just(digit)) { _ in
                                if digit < 1 {
                                    digit = 1
                                } else if digit > 9999 {
                                    digit = 9999
                                }
                            }
                            Stepper("", value: $digit, in: 1...9999)
                                        .labelsHidden()
                    }
                    Picker("单位", selection: $unit, content: {
                        ForEach(TimeUnit.allCases, id:\.self) {
                            Text($0.rawValue)
                        }
                    })
                    HStack {
                        Text("提醒时间")
                        Spacer()
                        Text("\(start.forward(number: self.digit, unit: self.unit).standard)")
                            .foregroundColor(.secondary)
                    }
                }
                
            }, header: {
                Text("提醒周期")
            })
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(category == .cycle ? "新增物品" : "新增事件")
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
        if self.cycleNotify {
            newItem.end = self.start.forward(number: self.digit, unit: self.unit)
        } else {
            newItem.end = self.start
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
    static var previews: some View {
        NavigationView {
            AddView(show: $value, category: .cycle)
                .preferredColorScheme(.light)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
        NavigationView {
            AddView(show: $value, category: .daily)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
