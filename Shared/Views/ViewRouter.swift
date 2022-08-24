//
//  ViewRouter.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI

struct ViewRouter: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var navData: NavData
    @State var showingLaunchScreen: Bool = true
    #if !os(macOS)
    init() {
        // Haptic Feedback
        let generator = UIImpactFeedbackGenerator()
        generator.prepare()
        generator.impactOccurred(intensity: 0.7)
    }
    #endif
    
    @Sendable private func delayView() async {
        // Delay of 7.5 seconds (1 second = 1_000_000_000 nanoseconds)
        try? await Task.sleep(nanoseconds: 7_500_000_000)
        showingLaunchScreen = false
    }
    
    var body: some View {
        if showingLaunchScreen {
            GeometryReader { geometry in
                ZStack {
                    HeartsAnimation()
                        .task(delayView)
                    VStack {
                       Spacer()
                        Image("Logo_Transparent")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    HeartsAnimation()
                        .task(delayView)
                    
                }
                .onTapGesture {
                    showingLaunchScreen = false
                    #if os(iOS)
                    Haptics.shared.play(.medium)
                    #endif
                }
                .appBackground()
            }
            
        } else {
            GeometryReader { geometry in
                ZStack {
                    #if os(macOS)
                    LandscapeViewWrapper()
                        .environmentObject(appData)
                        .environmentObject(navData)
                    #else
                    if UIDevice.isIpad && geometry.size.width > geometry.size.height {
                        LandscapeViewWrapper()
                            .environmentObject(appData)
                            .environmentObject(navData)
                    } else {
                        PortraitViewWrapper()
                            .environmentObject(appData)
                            .environmentObject(navData)
                    }
                    #endif
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .onAppear() {
                    print("Refreshed View!")
                }
                
                .appBackground()
            }
        }
       
        
    }
}
struct PortraitViewWrapper: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var navData: NavData
    init() {
        #if !os(macOS)
        UITabBar.appearance().backgroundColor = UIColor(Color("NavigationTab"))
        #endif
    }
    var body: some View {
        GeometryReader { geometry in
            TabView (selection: $navData.navigationSelection) {
                ForEach(navData.navigationItems) { navItem in
                    navigationViewSelect(view: navItem.name)
                        .frame(width: geometry.size.width * 0.95, height: geometry.size.height)
                        .appBackground()
                        .tabItem {
                            Label(navItem.name, systemImage: navItem.image)
                        }
                        .tag(navItem.name)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .appBackground()
    }
}

struct LandscapeViewWrapper: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var navData: NavData
    var body: some View {
        GeometryReader { geometry in
            HStack (spacing: 0){
                NavigationSideBarView()
                    .frame(width: geometry.size.width * 0.2)
                    .environmentObject(appData)
                    .environmentObject(navData)
                VStack (alignment: .center){
                    Spacer()
                    ZStack {
                        switch navData.navigationSelection {
                            case "Home":
                                HomeView()
                            case "Image Selection":
                                ImageSelectView()
                            case "Flag Selection":
                                FlagSelectionView()
                            case "Image Overlay":
                                ImageOverlayView()
                            case "Review":
                                ReviewView()
                            case "Settings":
                                SettingsView()
                            default:
                                HomeView()
                        }
                        //navigationViewSelect(view: navData.navigationSelection)
                    }
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.95)
                        .environmentObject(appData)
                        .environmentObject(navData)
                    Spacer()
                }
            }
            .onAppear() {
                appData.showingNavBar = true
                print("Router: ShowingNav? \(appData.showingNavBar)")
            }
        }
    }
}

struct StandardButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            return configuration.label
                .padding(4)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color("prideOrange"))
                .foregroundColor(.white)
                .font(.title3)
                .minimumScaleFactor(0.0001)
                .lineLimit(1)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 2)
                )
                .opacity(configuration.isPressed ? 0.7 : 1)
                .scaleEffect(configuration.isPressed ? 0.8 : 1)
        }
    }
}

struct FlagButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            return configuration.label
                .padding(4)
                .frame(width: geometry.size.height * 0.25, height: geometry.size.height * 0.25)
                .background(Color("prideOrange"))
                .foregroundColor(.white)
                .font(.title3)
                .minimumScaleFactor(0.0001)
                .lineLimit(1)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 2)
                )
                .opacity(configuration.isPressed ? 0.7 : 1)
                .scaleEffect(configuration.isPressed ? 0.8 : 1)
        }
    }
}


struct SideBarView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var navData: NavData
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .center, spacing: 10){
                Spacer()
                    .frame(height: geometry.size.height * 0.05)
                // Banner
                Banner(title: "Navigation")
                Spacer()
                // Navigation Links
                VStack (spacing: 20) {
                    ForEach(navData.navigationItems) { navItem in
                        Button {
                            navData.navigationSelection = navItem.name
                        } label: {
                            HStack {
                                Text("\(Image(systemName: navItem.image)) \(navItem.name)")
                                    .foregroundColor(navData.navigationSelection == navItem.name ? Color("progressIndigo") : .white)
                                Spacer()
                            }
                        }
                        .buttonStyle(StandardButton())
                        .frame(height: geometry.size.height * 0.05)
                    }
                }
                .frame(width: geometry.size.width * 0.8)
                Spacer()
            }
            .frame(width: geometry.size.width)
            .background(Color.red)
        }
    }
}

struct BottomNavigation: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var navData: NavData
    init() {
        #if !os(macOS)
        UITabBar.appearance().backgroundColor = UIColor(Color("NavigationTab"))
        #endif
    }
    var body: some View {
        TabView (selection: $navData.navigationSelection) {
            ForEach(navData.navigationItems) { navItem in
                navigationViewSelect(view: navItem.name)
                    .tabItem {
                        Label(navItem.name, systemImage: navItem.image)
                    }
                    .tag(navItem.name)
            }
        }
    }
}

struct ViewRouter_Previews: PreviewProvider {
    static var previews: some View {
        ViewRouter()
            .environmentObject(AppData())
            .environmentObject(NavData())
    }
}
