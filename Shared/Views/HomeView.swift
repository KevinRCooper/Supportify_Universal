//
//  HomeView.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI
#if !os(macOS)
import SSSwiftUIGIFView
#endif
struct HomeView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var navData: NavData
    @AppStorage("useHaptics") var useHaptics: Bool?
    
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .center){
                #if !os(macOS)
                if UIDevice.isiPhone {
                    Spacer()
                        .frame(height: geometry.size.height * 0.05)
                }
                #endif
                VStack {
                    Banner(title: "Supportify", subTitle: "Show your support for the LGBTQ+ Community!")
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                // Profile Image View
                Spacer()
                ImageOverlayWrapper()
                    .coordinateSpace(name: "ImageOverlay")
                    .frame(width: (geometry.size.width < geometry.size.height ? geometry.size.width * 0.8 : geometry.size.height * 0.6), height: (geometry.size.width < geometry.size.height ? geometry.size.width * 0.8 : geometry.size.height * 0.6))
                    
                Spacer()
                //Next Button
                Button {
                    navData.navigationSelection = "Image Selection"
                    #if os(iOS)
                    if useHaptics ?? true {
                        Haptics.shared.play(.medium)
                    }
                    #endif
                } label: {
                    Text("Select an Image")
                   
                }
                .buttonStyle(StandardButton())
                .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.05)
                Spacer()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppData())
            .environmentObject(NavData())
    }
}
