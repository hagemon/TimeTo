//
//  AcknowledgeView.swift
//  TimeTo
//
//  Created by Hagemon on 2021/11/20.
//

import SwiftUI

struct AcknowledgeView: View {
    var body: some View {
        Form {
            HStack {
                Text("Illustations are from ")
                Spacer()
                Button(action: {
                    let myUrl = "https://undraw.co"
                    let url: NSURL = URL(string: myUrl)! as NSURL
                    UIApplication.shared.open(url as URL)
                }, label: {
                    Text("Undraw.co")
                })
                    .buttonStyle(.bordered)
            }
        }
    }
}

struct AcknowledgeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AcknowledgeView()
        }
    }
}
