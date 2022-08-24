//
//  ReviewView.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/23/22.
//

import SwiftUI

struct ReviewView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var navData: NavData
    @State var showingSizeOptions: Bool = false
    @State var showingDone: Bool = false
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack (alignment: .center){
                    #if !os(macOS)
                    // Add padding if on iPhone
                    if UIDevice.isiPhone {
                        Spacer()
                            .frame(height: geometry.size.height * 0.05)
                    }
                    #endif
                    // Banner
                    VStack {
                        Banner(title: "Review", subTitle: "Preview your image and save!")
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                    // Profile Image View
                    Spacer()
                    ImageOverlayWrapper()
                        .coordinateSpace(name: "ImageOverlay")
                        .frame(width: (geometry.size.width < geometry.size.height ? geometry.size.width * 0.8 : geometry.size.height * 0.6), height: (geometry.size.width < geometry.size.height ? geometry.size.width * 0.8 : geometry.size.height * 0.6))
                        
                    Spacer()
                    //Save Button
                    Button {
                        #if os(macOS)
                        func saveImage() {
                            let path = appData.showSavePanel()
                            appData.outputImage = ImageSaveView(
                                width: (geometry.size.width < geometry.size.height ? geometry.size.width * 0.8 : geometry.size.height * 0.6),
                                height: (geometry.size.width < geometry.size.height ? geometry.size.width * 0.8 : geometry.size.height * 0.6)
                            ).environmentObject(appData).snapshot()
                            let image = appData.outputImage
                            let imageRepresentation = NSBitmapImageRep(data: image!.tiffRepresentation!)
                            let pngData = imageRepresentation?.representation(using: .png, properties: [:])
                            do {
                                try pngData!.write(to: path!)
                            } catch {
                                print(error)
                            }
                        }
                        saveImage()
                        appData.showingDoneScreen = true
                        #else
                        func pngFrom(image: UIImage) -> UIImage {
                            let imageData = image.pngData()!
                            let imagePng = UIImage(data: imageData)!
                            return imagePng
                        }
                        let image = pngFrom(
                            image: ImageSaveView(
                                width: (geometry.size.width < geometry.size.height ? geometry.size.width * 0.8 : geometry.size.height * 0.6),
                                height: (geometry.size.width < geometry.size.height ? geometry.size.width * 0.8 : geometry.size.height * 0.6)
                            )
                            .environmentObject(appData)
                            .asUiImage()
                        )
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        #endif
                        withAnimation {
                            appData.showingDoneScreen = true
                        }
                    } label: {
                        Text("Save")
                    }
                    .buttonStyle(StandardButton())
                    .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.05)
                    Spacer()
                }
                .blur(radius: appData.showingDoneScreen ? appData.alertBackgroundViewBlur : 0.0)
                // Save Options
                if appData.showingSizeOptions {
                    ImageSizeView()
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.5)
                        .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                        .environmentObject(appData)
                }
                if appData.showingDoneScreen {
                    CustomAlert()
                        .transition(.scale)
                        .frame(width: geometry.size.width * 0.90, height: geometry.size.height * 0.7)
                        .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                        .environmentObject(appData)
                }
            }
            
        }
    }
    
}

struct ImageSaveView: View {
    @EnvironmentObject var appData: AppData
    let width: CGFloat?
    let height: CGFloat?
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 15)
            HStack {
                Spacer()
                    .frame(width: 25)
                ImageOverlayWrapper()
                    .environmentObject(appData)
                    .frame(width: width ?? 1000, height: height ?? 1000)
                Spacer()
                    .frame(width: 25)
            }
            Spacer()
                .frame(height: 35)
        }
        .frame(width: ((width ?? 1000) + CGFloat(60)), height: ((height ?? 1000) + CGFloat(60)))
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView()
            .environmentObject(AppData())
            .environmentObject(NavData())
    }
}
