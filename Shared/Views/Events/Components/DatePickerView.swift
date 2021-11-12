//
//  DatePickerView.swift
//  TimeTo
//
//  Created by Hagemon on 2021/11/1.
//

import SwiftUI

struct DatePickerView: View {
    
    @Binding var date: Date
    
    var body: some View {
        VStack {
            DatePicker(selection: $date, label: {})
                .datePickerStyle(.graphical)
            Spacer()
        }
        .padding()
        .navigationTitle("设置时间")
    }
}

struct DatePickerView_Previews: PreviewProvider {
    @State static var date: Date = Date.now
    static var previews: some View {
        NavigationView {
            DatePickerView(date: $date)
        }
        .preferredColorScheme(.light)
    }
}
