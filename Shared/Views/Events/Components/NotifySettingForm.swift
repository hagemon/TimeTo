//
//  NotifySettingForm.swift
//  TimeTo
//
//  Created by Hagemon on 2021/11/8.
//

import SwiftUI
import Combine

struct NotifySettingForm: View {
    
    @Binding var digit: Int
    @Binding var unit: TimeUnit
    
    var body: some View {
        HStack {
            Text("Every")
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
        HStack {
            Text("Unit")
            Spacer()
            Menu(content: {
                Picker("Unit", selection: $unit, content: {
                    ForEach(TimeUnit.allCases, id:\.self) {
                        Text(LocalizeUtil.getLocalizedUnit(unit: $0.rawValue))
                    }
                })
            }, label: {
                Button(action: {}, label: {
                    Text("\(LocalizeUtil.getLocalizedUnit(unit: unit.rawValue))")
                })
                    .frame(minWidth: 100, alignment: .trailing)
                    .buttonStyle(.bordered)
            })
            
        }
//        Picker("单位", selection: $unit, content: {
//            ForEach(TimeUnit.allCases, id:\.self) {
//                Text($0.rawValue)
//            }
//        })
    }
}

struct NotifySettingForm_Previews: PreviewProvider {
    @State static var digit = 1
    @State static var unit: TimeUnit = .hour
    static var previews: some View {
        NavigationView {
            Form {
                Section {
                    NotifySettingForm(digit: $digit, unit: $unit)
                }
            }
        }
    }
}
