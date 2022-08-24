//
//  ImageSelectView.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI

struct ImageSelectView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var navData: NavData
    //@State var hasImageBeenSelected: Bool = false
    @State var isImagePickerDisplay = false
    @State private var isShowingImageSelectView = false
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .center){
                #if !os(macOS)
                if UIDevice.isiPhone {
                    Spacer()
                        .frame(height: geometry.size.height * 0.05)
                }
                #endif
                // Banner
                VStack {
                    #if os(macOS)
                    Banner(title: "Image Selection", subTitle: "Upload a photo")
                    #else
                    Banner(title: "Image Selection", subTitle: "Take or upload a photo")
                    #endif
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                // Profile Image View
                Spacer()
                ImageOverlayWrapper()
                    .frame(width: (geometry.size.width < geometry.size.height ? geometry.size.width * 0.8 : geometry.size.height * 0.6), height: (geometry.size.width < geometry.size.height ? geometry.size.width * 0.8 : geometry.size.height * 0.6))
                    
                Spacer()
                if !appData.hasImageBeenSelected {
                    //Image Source Selection
                    HStack {
                        #if os(macOS)
                        Button {
                            appData.openImage()
                            appData.hasImageBeenSelected = true
                        } label: {
                            Text("Upload Photo \(Image(systemName: "camera.viewfinder"))")
                        }
                        .buttonStyle(StandardButton())
                        .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.05)
                        #else
                        Button {
                            appData.sourceType = .camera
                            self.isImagePickerDisplay.toggle()
                            appData.hasImageBeenSelected = true

                            Haptics.shared.play(.medium)
                        } label: {
                            Text("Take Photo \(Image(systemName: "camera.viewfinder"))")
                        }
                        .buttonStyle(StandardButton())
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.05)
                        Button {
                            appData.sourceType = .photoLibrary
                            self.isImagePickerDisplay.toggle()
                            appData.hasImageBeenSelected = true
                            Haptics.shared.play(.medium)
                        } label: {
                            Text("Upload Photo \(Image(systemName: "camera.viewfinder"))")
                        }
                        .buttonStyle(StandardButton())
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.05)
                        #endif
                    }
                } else {
                    //Next or Retake Photo
                    HStack {
                        Button {
                            appData.hasImageBeenSelected = false
                        } label: {
                            Text("Change Image \(Image(systemName: "return"))")
                        }
                        .buttonStyle(StandardButton())
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.05)
                        Button {
                            navData.navigationSelection = "Flag Selection"
                            #if os(iOS)
                            Haptics.shared.play(.medium)
                            #endif
                        } label: {
                            Text("Select Flag Overlay \(Image(systemName: "arrow.forward.circle"))")
                        }
                        .buttonStyle(StandardButton())
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.05)
                    }
                }
                #if os(macOS)
                Spacer()
                #endif
                // MARK: - Image Picker Display (Camera or Album)
                ImagePickerDisplay(isImagePickerDisplay: self.$isImagePickerDisplay)
                    .environmentObject(appData)
            }
            .appBackground()
        }
    }
}

struct ImagePickerDisplay: View {
    @EnvironmentObject var appData: AppData
    //@Binding var sourceType: UIImagePickerController.SourceType
    @Binding var isImagePickerDisplay : Bool
    var body: some View {
        #if !os(macOS)
        Spacer()
            .fullScreenCover(isPresented: self.$isImagePickerDisplay) {
                ImagePickerView()
                    .edgesIgnoringSafeArea(.all)
            }
        #endif
    }
}

struct ImageSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSelectView()
            .environmentObject(AppData())
            .environmentObject(NavData())
    }
}
