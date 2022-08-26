//
//  ImageOverlayView.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/22/22.
//

import SwiftUI

struct ImageOverlayView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var navData: NavData
    @AppStorage("useHaptics") var useHaptics: Bool?
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .center){
                #if !os(macOS)
                if UIDevice.isiPhone {
                    Spacer()
                        //.frame(height: geometry.size.height * 0.05)
                }
                
                #endif
                // Banner
                VStack {
                    Banner(title: "Image Overlay")
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.05)
                // Profile Image View
                Spacer()
                ImageOverlayWrapper()
                    .frame(width: (geometry.size.width < geometry.size.height ? geometry.size.width * 0.8 : geometry.size.height * 0.6), height: (geometry.size.width < geometry.size.height ? geometry.size.width * 0.8 : geometry.size.height * 0.6))

                Spacer()
                    .frame(height: geometry.size.height * 0.07)
                // Overlay Options
                VStack {
                    // Overlay Type
                    Picker("Overlay Type", selection: $appData.imageDisplay) {
                        ForEach(appData.imageDisplayChoice, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle()
                    .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.05)
                    
                    // Displays Text Overlay if Applicable
                    if appData.imageDisplay == "Banner" {
                        Picker("Choose Text", selection: $appData.communityIdentification) {
                            ForEach(appData.communityIdentificationChoice, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle()
                    } else {
                        HStack {
                            Text("Outline Width")
                            Slider(value: $appData.imageDisplayLineWidth, in: 1...20)
                        }
                        .optionsSelection(extraPadding: false)
                    }
                    
                    // Zoom Level View
                    HStack {
                        Text("Zoom")
                        Slider(value: $appData.zoomLevel, in: 0.2...3.0)
                    }
                    .optionsSelection(extraPadding: false)
                    Spacer()
                        .frame(height: geometry.size.height * 0.025)
                    // Review
                    Button {
                        navData.navigationSelection = "Review"
                        #if os(iOS)
                        if useHaptics ?? true {
                            Haptics.shared.play(.medium)
                        }
                        #endif
                    } label: {
                        Text("Review Image & Save")
                    }
                    .buttonStyle(StandardButton())
                    .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.035)
                }
                .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.20)
                Spacer()
                    //.frame(height: geometry.size.height * 0.05)
            }
            .appBackground()
            .onAppear() {
                appData.userSeenOverlayScreen = true
            }
        }
    }
}

struct ImageOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        ImageOverlayView()
    }
}
