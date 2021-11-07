//
//  SettingsView.swift
//  TimeTo
//
//  Created by Hagemon on 2021/10/30.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @Binding var schema: ColorScheme?
    
    let allSchemas: [ColorScheme?] = [.none, .light, .dark]
    
    var body: some View {
        NavigationView {
            Form {
                Section(content: {
                    NavigationLink(destination: {
                        DateRangeView()
                    }, label: {
                        Text("通知设置")
                    })
                    Picker("主题", selection: $schema, content: {
                        ForEach(allSchemas, id:\.self) {
                            switch $0 {
                            case .none:
                                Text("自动")
                            case .light:
                                Text("浅色")
                            case .dark:
                                Text("深色")
                            case .some(_):
                                Text("")
                            }
                        }
                    })
                        .onChange(of: schema, perform: { s in
                            UserDefaults.standard.setSchema(schema: schema)
                        })
                })
                NavigationLink(destination: {
                    AboutView()
                }, label: {
                    Text("关于")
                })
//                NavigationLink(destination: {
//                    if MFMailComposeViewController.canSendMail() {
//                        MailView(result: self.$result)
//                    } else {
//                        Text("设备暂不支持发送邮件")
//                    }
//                }, label: {
//                    Text("反馈")
//                })
//                Button(action: {
//
//                }, label: {
//                    Text("☕️ 赞助一杯咖啡")
//                })
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        UserDefaults.standard.removeObject(forKey: "global_start")
//                        UserDefaults.standard.removeObject(forKey: "global_end")
//                    }, label: {
//                        Image(systemName: "trash")
//                    })
//                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    
        
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    @State static var schema: ColorScheme? = .none
    static var previews: some View {
        SettingsView(schema: $schema)
            .preferredColorScheme(.none)
    }
}
