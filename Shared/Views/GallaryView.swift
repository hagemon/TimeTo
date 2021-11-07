//
//  GallaryView.swift
//  TimeTo
//
//  Created by Hagemon on 2021/10/31.
//

import SwiftUI

struct GallaryView: View {
    
    @Binding var icon: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var symbols = ["moon.stars", "sun.haze.fill", "cloud.rain", "sun.min.fill", "cloud.sun.rain", "snowflake", "heart.circle", "facemask", "brain", "pills.fill", "mustache", "face.dashed", "pencil.slash", "paperplane", "internaldrive", "cart", "note.text", "books.vertical", "magazine", "paperclip", "umbrella", "flag", "eyeglasses", "camera", "scissors", "speedometer", "bandage", "wrench", "printer", "cross.case", "lock", "key", "cpu", "cup.and.saucer.fill", "gift", "flame", "ladybug", "leaf", "giftcard"]
        
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 80)),
            ], spacing: 20,  content: {
                ForEach(symbols, id: \.self) { symbol in
                    Button(action: {
                        self.icon = symbol
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: symbol)
                            .font(.system(size: 30))
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                            .cornerRadius(10)
                    })
                }
            })
        }
        .navigationTitle("选择图标")
        
    }
}

struct GallaryView_Previews: PreviewProvider {
    @State static var icon = "moon.star"
    static var previews: some View {
        NavigationView {
            GallaryView(icon: $icon)
        }
    }
}
