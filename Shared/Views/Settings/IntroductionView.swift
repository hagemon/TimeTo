//
//  IntroductionView.swift
//  TimeTo
//
//  Created by Hagemon on 2021/11/8.
//

import SwiftUI
import Combine

struct IntroductionView: View {
    
    @Binding var show: Bool
    
    @State private var notify: Bool = true
    @State private var name: String = ""
    @State private var icon: String = "moon.stars"
    @State private var digit: Int = 1
    @State private var unit: TimeUnit = .hour
    @State private var start: Date = Date.now
    
    @State private var cycleNotify: Bool = true
    @State private var globalNotify: Bool = true
    
    init(show: Binding<Bool>){
//        UITableView.appearance().backgroundColor = .clear
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        _show = show
    }
        
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.show = false
                    UserDefaults.standard.setLogin()
                }, label: {
                    Image(systemName: "multiply.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                })
                    .padding(.trailing, 20)
            }
            .offset(CGSize(width: 0, height: 50))
            .ignoresSafeArea()
            Image("Icon")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .cornerRadius(10)
            TabView {
                
                // First Tab
                Form {
                    IntroInfo(icon: icon, title: "Cycle Slogan".localized, name: "Socks".localized)
                    Section(content: {
                        HStack {
                            Text("Start Time")
                            Spacer()
                            Text("\(start.standard)")
                            Image(systemName: "chevron.forward")
                                .foregroundColor(.secondary)
                        }
                        IntroNotifyView(digit: $digit)
                        HStack {
                            Text("Notification Time")
                            Spacer()
                            Text("\(start.forward(number: self.digit, unit: self.unit).standard)")
                                .foregroundColor(.secondary)
                        }
                    })
                }
                // Second Tab
                Form {
                    IntroInfo(icon: "cup.and.saucer.fill", title: "Daily Slogan".localized, name: "Tea".localized)
                    Section(content: {
                        
                        Toggle("Repeat", isOn: self.$cycleNotify)
                        HStack {
                            Text("Notification Time")
                            Spacer()
                            Text("\(start.forward(number: self.digit, unit: self.unit).standard)")
                                .foregroundColor(.secondary)
                        }
                        if self.cycleNotify {
                            IntroNotifyView(digit: $digit)
                        }
                    })
                }
                // Third Tab
                VStack {
                    Form {
                        Section {
                            Toggle(isOn: $globalNotify){
                                Text("Allow Notifications")
                            }
                                .toggleStyle(.switch)
                        }
                        Section {
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.show = false
                                    UserDefaults.standard.setLogin()
                                    if globalNotify {
                                        NotifyTools.requestAuth()
                                    }
                                }, label: {
                                    Text("TimeTo")
                                })
                                    .buttonStyle(.bordered)
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    Spacer()
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            Spacer()
        }
//        .background(Color("IconBackColor"))
        .background(Color(UIColor.systemGroupedBackground))
//        .preferredColorScheme(.dark)
//        .onAppear(perform: {
//            UITableView.appearance().backgroundColor = .clear
//            UIPageControl.appearance().currentPageIndicatorTintColor = .black
//            UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
//        })
    }
}

fileprivate struct IntroInfo: View {
    
    private var icon: String
    private var title: String
    private var name: String
    
    init(icon: String, title: String, name: String) {
        self.icon = icon
        self.title = title
        self.name = name
    }
    
    var body: some View {
        Section(content: {
            HStack {
                Text("Icon")
                Spacer()
                Image(systemName: icon)
                Image(systemName: "chevron.forward")
                    .foregroundColor(.secondary)
            }
            HStack {
                Text("Name")
                Spacer()
                Text(name)
            }
        }, header: {
            HStack {
                Spacer()
                Text(title)
                Spacer()
            }
            .font(.title)
            .foregroundColor(.accentColor)
            .padding(.bottom, 5)
        })
    }
}

fileprivate struct IntroNotifyView: View {
    
    @Binding var digit: Int
    
    var body: some View {
        HStack {
            Text("Every")
            Text("\(digit)")
            Spacer()
            Stepper("", value: $digit, in: 1...9999)
                .labelsHidden()
                .disabled(true)
        }
        HStack {
            Text("Unit")
            Spacer()
            Text("Hour")
            Image(systemName: "chevron.forward")
                .foregroundColor(.secondary)
        }
    }
}

struct IntroductionView_Previews: PreviewProvider {
    @State static private var show: Bool = true
    static var previews: some View {
        NavigationView {
            IntroductionView(show: $show)
        }
    }
}
