//
//  BasicInfoForm.swift
//  TimeTo
//
//  Created by Hagemon on 2021/11/8.
//

import SwiftUI

struct BasicInfoForm: View {
    
    @Binding var icon: String
    @Binding var name: String
    @Binding var notify: Bool
    
    var body: some View {
        NavigationLink(destination: {
            GallaryView(icon: $icon)
        }, label: {
            Text("Icon")
            Spacer()
            Image(systemName: icon)
        })
        HStack {
            Text("Name")
            TextField("Item Name", text: $name)
                .multilineTextAlignment(.trailing)
        }
        Toggle("Notification On", isOn: $notify)
    }
}

struct BasicInfoForm_Previews: PreviewProvider {
    @State static var icon = "moon.stars"
    @State static var name = "什么呢🤔️"
    @State static var notify = true
    static var previews: some View {
        NavigationView {
            Form {
                Section {
                    BasicInfoForm(icon: $icon
                                  , name: $name, notify: $notify)
                }
            }
        }
    }
}

