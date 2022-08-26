//
//  ViewRouter.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI
#if os(iOS)
import SSSwiftUIGIFView
#endif

struct ViewRouter: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var navData: NavData
    @State var showingLaunchScreen: Bool = true
    @State var imageSize: CGSize = .zero
    @AppStorage("startAnimation") var startAnimation: Bool?
    @AppStorage("useHaptics") var useHaptics: Bool?
    #if !os(macOS)
    init() {
        // Haptic Feedback
        if useHaptics ?? true {
            let generator = UIImpactFeedbackGenerator()
            generator.prepare()
            generator.impactOccurred(intensity: 0.7)
        }
    }
    #endif
    
    @Sendable private func delayView() async {
        // Delay of 7.5 seconds (1 second = 1_000_000_000 nanoseconds)
        try? await Task.sleep(nanoseconds: 7_500_000_000)
        showingLaunchScreen = false
    }
        
    var body: some View {
        if showingLaunchScreen && startAnimation ?? true {
            GeometryReader { geometry in
                ZStack {
                    HeartsAnimation()
                        .task(delayView)
                    VStack {
                        #if os(macOS)
                        Image("Logo_Transparent")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5)
                        #else
                        Spacer()
                        SwiftUIGIFPlayerView(gifName: "Logo_Animated")
                            .scaledToFit()
                            .ignoresSafeArea()
                            //.frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                            .frame(width: geometry.size.width < geometry.size.height ? geometry.size.width * 0.7 : geometry.size.height * 0.6)
     
                        #endif
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                    HeartsAnimation()
                    
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
        UITabBar.appearance().barTintColor = UIColor.purple
        #endif
    }
    var body: some View {
        GeometryReader { geometry in
            TabView (selection: $navData.navigationSelection) {
                ForEach(navData.navigationItems) { navItem in
                    if navItem.name != "Home" {
                        navigationViewSelect(view: navItem.name)
                            .frame(width: geometry.size.width * 0.95, height: geometry.size.height)
                            .appBackground()
                            .tabItem {
                                Label(navItem.name, systemImage: navItem.image)
                            }
                            .tag(navItem.name)
                    }
                    
                }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.2.fill")
                    }
                    .tag("Settings")
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
                                .transition(.move(edge: .trailing))
                            case "Image Selection":
                                ImageSelectView()
                                .transition(.move(edge: .trailing))
                            case "Flag Selection":
                                FlagSelectionView()
                                .transition(.move(edge: .trailing))
                            case "Image Overlay":
                                ImageOverlayView()
                                .transition(.move(edge: .trailing))
                            case "Review":
                                ReviewView()
                                .transition(.move(edge: .trailing))
                            case "Settings":
                                SettingsView()
                                .transition(.move(edge: .trailing))
                            default:
                                HomeView()
                                .transition(.move(edge: .trailing))
                        }
                        //navigationViewSelect(view: navData.navigationSelection)
                    }
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.95)
                        .environmentObject(appData)
                        .environmentObject(navData)
                        .animation(.easeInOut(duration: 0.5))
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
                    .transition(.move(edge: .trailing))
                    .tabItem {
                        Label(navItem.name, systemImage: navItem.image)
                    }
                    .tag(navItem.name)
            }
            
        }
        .animation(.easeInOut(duration: 0.5), value: navData.navigationSelection)
    }
}

struct ViewRouter_Previews: PreviewProvider {
    static var previews: some View {
        ViewRouter()
            .environmentObject(AppData())
            .environmentObject(NavData())
    }
}
