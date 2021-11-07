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
                NavigationLink(destination: {
                    GallaryView(icon: $icon)
                }, label: {
                    Text("图标")
                    Spacer()
                    Image(systemName: icon)
                })
                HStack {
                    Text("名称")
                    TextField("item", text: $name)
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
        .navigationTitle(category == .cycle ? "修改物品" : "修改事件")
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
            if self.cycleNotify {
                self.item.end = item.start!.forward(
                    number: Int(item.digit),
                    unit: TimeUnit(rawValue: item.unit!) ?? .hour
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
