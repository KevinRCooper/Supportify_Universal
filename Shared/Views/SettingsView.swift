//
//  SettingsView.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI
#if os(macOS)
struct SettingsView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var navData: NavData
    @AppStorage("startAnimation") var startAnimation = true
    @AppStorage("animatedLogo") var usingAnimatedLogo = false
    @AppStorage("useHaptics") var useHaptics = true
    @AppStorage("developer") private var developer = false
    @AppStorage("review.counter") private var reviewCounter = 0
    @AppStorage("review.version") private var reviewVersion = 1.0
    @AppStorage("review.promptSeen") private var reviewPromptSeen = false
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Banner
                HStack {
                    Banner(title: "Settings")
                        .foregroundColor(.white)
                    Spacer()
                }
                // Settings Content
                // App Behavior
                List {
                    Section {
                        Toggle(isOn: $startAnimation) {
                            Text("Show start animation?")
                        }
                        .toggleStyle(.switch)
                    } header: {
                        Text("App Bahvior")
                    }
                }
                // Support
                List {
                    Section {
                        Link("Join our Discord", destination: URL(string: "https://discord.gg/cKrcv8mmRE")!)
                    } header: {
                        Text("Support")
                    }
                }
                // Developer
                List {
                    Section {
                        Toggle(isOn: $developer) {
                            Text("Show developer information?")
                        }
                        .toggleStyle(.switch)
                        if developer {
                            Text("Developer Information: Created by Kevin Cooper")
                            Text("Build: Supportify Univerval 1.0")
                            Link("GitHub Project (Open Source MIT License)", destination: URL(string: "https://github.com/NotEnoughCoffee/Supportify_Universal")!)
                            Text("Review Counter: \(reviewCounter) | User seen review prompt? \(reviewPromptSeen ? "Yes" : "No")")
                        }
                    } header: {
                        Text("Developer")
                    }
                }
            }
            .padding()
            .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.75)
            .background(Color("DarkGray"))
            .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
        }
    }
}
#else

struct SettingsView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var navData: NavData
    @AppStorage("startAnimation") var startAnimation = true
    @AppStorage("animatedLogo") var usingAnimatedLogo = false
    @AppStorage("useHaptics") var useHaptics = true
    @AppStorage("developer") var developer = false
    @AppStorage("review.counter") private var reviewCounter = 0
    @AppStorage("review.version") private var reviewVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    @AppStorage("review.promptSeen") private var reviewPromptSeen = false
    
    
    #if !os(macOS)
    init(){
           UITableView.appearance().backgroundColor = .clear
       }
    #endif
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 20)
            VStack (alignment: .leading){
                
                HStack {
                    Spacer()
                        .frame(width: 20)
                    Text("Settings")
                        .font(Font.largeTitle.weight(.bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                
                Form {
                    List {
                        Section {
                            Toggle(isOn: $startAnimation) {
                                Text("Show start animation?")
                            }
                            Toggle(isOn: $usingAnimatedLogo) {
                                Text("Show animated images?")
                            }
                            Toggle(isOn: $useHaptics) {
                                Text("Use haptic feedback?")
                            }
                        } header: {
                            Text("App Bahavior")
                                .foregroundColor(.white)
                        }
                    }
                    
                    Section(header: Text("Support").foregroundColor(.white)) {
                    
                        Link("Join our Discord", destination: URL(string: "https://discord.gg/cKrcv8mmRE")!)
                    }
                    Section(header: Text("Developer").foregroundColor(.white)) {
                        Toggle(isOn: $developer) {
                            Text("Show developer information?")
                        }
                        if developer {
                            Text("Developer Information: Created by Kevin Cooper")
                            Text("Build: Supportify Universal \(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "")")
                            Link("GitHub Project (Open Source MIT License)", destination: URL(string: "https://github.com/NotEnoughCoffee/Supportify_Universal")!)
                            Text("Review Counter: \(reviewCounter) | User seen review prompt? \(reviewPromptSeen ? "Yes" : "No")")
//                            Button {
//                                appData.showingPromotional = true
//                            } label: {
//                                Text("Show Promotional Page")
//                            }
                        }
                        
                    }
                }
                
            }
            Spacer()
                .frame(width: 20)
        }
        .frame(width: .infinity, height: .infinity)
        .appBackground()
    }
}
#endif

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppData())
            .environmentObject(NavData())
    }
}
