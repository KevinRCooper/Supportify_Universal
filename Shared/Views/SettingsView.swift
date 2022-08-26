//
//  SettingsView.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI

struct SettingsView2: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var navData: NavData
    @AppStorage("startAnimation") var startAnimation = true
    @AppStorage("animatedLogo") var usingAnimatedLogo = false
    @AppStorage("useHaptics") var useHaptics = true
    @AppStorage("developer") var developer = false
    @AppStorage("review.counter") private var reviewCounter = 0
    @AppStorage("review.version") private var reviewVersion = 1.0
    @AppStorage("review.promptSeen") private var reviewPromptSeen = false
    
    #if !os(macOS)
    init(){
           UITableView.appearance().backgroundColor = .clear
       }
    #endif
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                    .frame(width: geometry.size.width * 0.05)
                VStack (alignment: .leading){
                    // Title
                    HStack {
                        Text("Settings")
                            .font(Font.largeTitle.weight(.bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    // Form
                    List {
                        Section {
                            Toggle(isOn: $startAnimation) {
                                Text("Show start animation?")
                            }
                            #if os(iOS)
                            Toggle(isOn: $usingAnimatedLogo) {
                                Text("Show animated images?")
                            }
                            Toggle(isOn: $useHaptics) {
                                Text("Use haptic feedback?")
                            }
                            #endif
                            Section(header: Text("Support")) {
                                Link("Join our Discord", destination: URL(string: "https://discord.gg/cKrcv8mmRE")!)
                            }
                        } header: {
                            Text("App Behavior")
                                .foregroundColor(.white)
                        }
                        Section {
                            Toggle(isOn: $developer) {
                                Text("Show developer information?")
                            }
                            if developer {
                                Text("Developer Information: Created by Kevin Cooper")
                                Text("Build: Supportify Univerval 1.0")
                                Link("GitHub Project (Open Source MIT License)", destination: URL(string: "https://github.com/NotEnoughCoffee/Supportify_Universal")!)
                                Text("Review Counter: \(reviewCounter) | User seen review prompt? \(reviewPromptSeen ? "Yes" : "No")")
                            }
                        } header: {
                            Text("Developer")
                                .foregroundColor(.white)
                        }
                    }
                }
                Spacer()
                    .frame(width: geometry.size.width * 0.05)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var navData: NavData
    @AppStorage("startAnimation") var startAnimation = true
    @AppStorage("animatedLogo") var usingAnimatedLogo = false
    @AppStorage("useHaptics") var useHaptics = true
    @AppStorage("developer") var developer = false
    @AppStorage("review.counter") private var reviewCounter = 0
    @AppStorage("review.version") private var reviewVersion = 1.0
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
                            #if os(iOS)
                            Toggle(isOn: $usingAnimatedLogo) {
                                Text("Show animated images?")
                            }
                            Toggle(isOn: $useHaptics) {
                                Text("Use haptic feedback?")
                            }
                            #endif
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
                            Text("Build: Supportify Univerval 1.0")
                            Link("GitHub Project (Open Source MIT License)", destination: URL(string: "https://github.com/NotEnoughCoffee/Supportify_Universal")!)
                            Text("Review Counter: \(reviewCounter) | User seen review prompt? \(reviewPromptSeen ? "Yes" : "No")")
                        }
                        
                    }
                }
                
            }
            Spacer()
                .frame(width: 20)
        }
        .frame(width: .infinity, height: .infinity)
        #if os(macOS)
        .background(Color.black)
        #else
        .appBackground()
        #endif
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppData())
            .environmentObject(NavData())
    }
}
