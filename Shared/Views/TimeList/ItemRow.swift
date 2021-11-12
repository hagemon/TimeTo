//
//  ItemRow.swift
//  TimeTo
//
//  Created by Hagemon on 2021/10/28.
//

import SwiftUI

struct ItemRow: View {
    
    @ObservedObject var item: Item
    @Binding var date: Date
    
    var body: some View {
        if item.name != nil {
            HStack {
                Image(systemName: item.icon ?? "moon.star")
                    .frame(width: 30, height: 50, alignment: .center)
                Text(item.name!)
                Spacer()
                if item.isExpired(now: Date.now) {
                    Image(systemName: "arrow.forward")
                    Text("右滑完成")
                } else {
                    Text("\(item.getGap(now: date))")
                }
            }
        }
    }
}

struct ItemRow_Previews: PreviewProvider {
    @State static var date = Date.now
    static var previews: some View {
        Form {
            ItemRow(item: demo_item, date: $date)
                .padding()
                .preferredColorScheme(.dark)
                .previewLayout(.fixed(width: 350, height: 50))
            ItemRow(item: experied_item, date: $date)
                .padding()
                .preferredColorScheme(.dark)
                .previewLayout(.fixed(width: 350, height: 50))
        }
        
    }
}
