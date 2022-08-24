//
//  SettingsView.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var navData: NavData
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .center){
                Spacer()
                    .frame(height: geometry.size.height * 0.05)
                // Banner
                VStack {
                    Banner(title: "Settings", subTitle: "")
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                // Profile Image View
                Spacer()
                ImageOverlayWrapper()
                #if os(macOS)
                    .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.6)
                #else
                    .frame(width: geometry.size.width * (UIDevice.isIpad ? 0.7 : 0.9), height: geometry.size.height * (geometry.size.width > geometry.size.height ? 0.6 : 0.4))
                #endif
                    
                Spacer()
                //Next Button
                Button {
                    navData.navigationSelection = "Image Selection"
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppData())
            .environmentObject(NavData())
    }
}
