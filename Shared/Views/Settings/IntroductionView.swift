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
    @State private var name: String = "什么呢🤔"
    @State private var icon: String = "moon.stars"
    @State private var digit: Int = 1
    @State private var unit: TimeUnit = .hour
    @State private var start: Date = Date.now
    
    @State private var cycleNotify: Bool = true
    @State private var globalNotify: Bool = true
    
    init(show: Binding<Bool>){
        UITableView.appearance().backgroundColor = .clear
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
                    IntroInfo(icon: icon, title: "日常更换，规律生活", name: "袜子🧦")
                    Section(content: {
                        HStack {
                            Text("开始时间")
                            Spacer()
                            Text("\(start.standard)")
                            Image(systemName: "chevron.forward")
                                .foregroundColor(.gray)
                        }
                        IntroNotifyView(digit: $digit)
                        HStack {
                            Text("提醒时间")
                            Spacer()
                            Text("\(start.forward(number: self.digit, unit: self.unit).standard)")
                                .foregroundColor(.secondary)
                        }
                    })
                }
                // Second Tab
                Form {
                    IntroInfo(icon: "cup.and.saucer.fill", title: "定时提醒，得闲饮茶", name: "喝茶🍵")
                    Section(content: {
                        
                        Toggle("重复提醒", isOn: self.$cycleNotify)
                        HStack {
                            Text("提醒时间")
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
                                Text("开启通知")
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
                                    Text("是时候打开App了")
                                })
                                    .buttonStyle(.bordered)
                                Spacer()
                            }
                        }.listRowBackground(Color.clear)
                    }
                    Spacer()
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            Spacer()
        }
        .background(Color("IconBackColor"))
        .preferredColorScheme(.light)
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
                Text("图标")
                Spacer()
                Image(systemName: icon)
                Image(systemName: "chevron.forward")
                    .foregroundColor(.gray)
            }
            HStack {
                Text("名称")
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
            Text("每")
            Text("\(digit)")
            Spacer()
            Stepper("", value: $digit, in: 1...9999)
                .labelsHidden()
                .disabled(true)
        }
        HStack {
            Text("单位")
            Spacer()
            Text("小时")
            Image(systemName: "chevron.forward")
                .foregroundColor(.gray)
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
