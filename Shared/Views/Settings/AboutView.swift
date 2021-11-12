//
//  AboutView.swift
//  TimeTo
//
//  Created by Hagemon on 2021/11/3.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {

            Form {
                HStack {
                    Spacer()
                    Image("about_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                    Spacer()
                }.listRowBackground(Color.clear)
                
                Section {
                    Text("Hagemon")
                    Text("喜欢干净，热爱自由。")
                }
                
                Button(action: {
                    let myUrl = "https://github.com/hagemon"
                    let url: NSURL = URL(string: myUrl)! as NSURL
                    UIApplication.shared.open(url as URL)
                }, label: {
                    HStack {
                        Text("Github")
                        Spacer()
                        Image("github")
                            .resizable()
                            .frame(width: 28, height: 28, alignment: .center)
                    }
                })
                
                Button(action: {
                    let myUrl = "https://twitter.com/oneFolder_"
                    let url: NSURL = URL(string: myUrl)! as NSURL
                    UIApplication.shared.open(url as URL)
                }, label: {
                    HStack {
                        Text("Twitter")
                        Spacer()
                        Image("twitter")
                            .resizable()
                            .frame(width: 28, height: 28, alignment: .center)
                    }
                })
                
                Button(action: {
                    let myUrl = "https://hagemon.github.io"
                    let url: NSURL = URL(string: myUrl)! as NSURL
                    UIApplication.shared.open(url as URL)
                }, label: {
                    HStack {
                        Text("Blog")
                        Spacer()
                        Image("blog")
                            .resizable()
                            .frame(width: 28, height: 28, alignment: .center)
                    }
                })
            }
            .navigationTitle("关于")
        .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView()
        }
        .preferredColorScheme(.dark)
        
    }
}
