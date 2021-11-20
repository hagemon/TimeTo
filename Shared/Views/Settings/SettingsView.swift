//
//  SettingsView.swift
//  TimeTo
//
//  Created by Hagemon on 2021/10/30.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var schema: ColorScheme?
    @State var showIntro: Bool = false
    
    let allSchemas: [ColorScheme?] = [.none, .light, .dark]
    
    var body: some View {
        NavigationView {
            Form {
                Section("General".localized, content: {
                    NavigationLink(destination: {
                        DateRangeView()
                    }, label: {
                        Text("Notification Settings")
                    })
                    Picker("Schema", selection: $schema, content: {
                        ForEach(allSchemas, id:\.self) {
                            switch $0 {
                            case .none:
                                Text("Automatic")
                            case .light:
                                Text("Light")
                            case .dark:
                                Text("Dark")
                            case .some(_):
                                Text("")
                            }
                        }
                    })
                        .onChange(of: schema, perform: { s in
                            UserDefaults.standard.setSchema(schema: schema)
                        })
                    Button(action: {
                        self.showIntro = true
                    }, label: {
                        Text("Introduction")
                    })
                        .fullScreenCover(isPresented: $showIntro, onDismiss: {}, content: {
                            IntroductionView(show: $showIntro)
                        })
                })
                NavigationLink(destination: {
                    AboutView()
                }, label: {
                    Text("About")
                })
                NavigationLink(destination: {
                    AcknowledgeView()
                }, label: {
                    Text("Acknowledgement")
                })
//                Button(action: {
//
//                }, label: {
//                    Text("☕️ 赞助一杯咖啡")
//                })
            }
            .navigationTitle("Settings")
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
        .navigationViewStyle(.stack)
        
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    @State static var schema: ColorScheme? = .none
    static var previews: some View {
        SettingsView(schema: $schema)
            .preferredColorScheme(.none)
    }
}
