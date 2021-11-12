//
//  DateRangeView.swift
//  TimeTo
//
//  Created by Hagemon on 2021/11/3.
//

import SwiftUI

struct DateRangeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.end, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var start: Date = UserDefaults.standard.getGlobalStart()
    @State private var end: Date = UserDefaults.standard.getGlobalEnd()
    
    var body: some View {
        Form {
            Section("在区间外的通知将会延迟提醒") {
                DatePicker(selection: $start, in: Date.clock(at: 0)...end, displayedComponents: .hourAndMinute, label: {
                    Text("开始时间")
                })
                    .datePickerStyle(.compact)
                DatePicker(selection: $end, in: start...Date.clock(at: 23, minute: 59, second: 59), displayedComponents: .hourAndMinute, label: {
                    Text("结束时间")
                    
                })
                    .datePickerStyle(.compact)
            }
        }
        .onAppear(perform: {
            start = UserDefaults.standard.getGlobalStart()
            end = UserDefaults.standard.getGlobalEnd()
        })
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    saveTimeConfig()
                    items.forEach({
                        item in
                    })
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("保存")
                })
            })
        })
        .navigationTitle("通知设置")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func saveTimeConfig() {
        UserDefaults.standard.set(start.hour, forKey: "global_start")
        UserDefaults.standard.set(end.hour, forKey: "global_end")
        items.forEach({ item in
            item.setNotification()
        })
    }
}

struct DateRangeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DateRangeView()
        }
    }
}
