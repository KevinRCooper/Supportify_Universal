//
//  CustomAlert.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/23/22.
//

import SwiftUI

struct CustomAlert: View {
    @EnvironmentObject var appData: AppData
    @Environment(\.openURL) private var openURL
    @State private var scale = 0.0
    @State var showingPhotoAlbum: Bool = true
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                    .frame(height: geometry.size.height * 0.05)
                #if os(macOS)
                Banner(title: "Image Saved!")
                    .frame(width: geometry.size.width * 0.95)
                #else
                Banner(title: "Image Saved!", subTitle: "Go to your photo album to see your new profile image")
                    .frame(width: geometry.size.width * 0.95)
                #endif
                    
                Divider()
                Spacer()
                Button {
                    #if os(macOS)
                    appData.showingDoneScreen = false
                    #else
                    if showingPhotoAlbum {
                        if let url = URL(string: "photos-redirect://") {
                            openURL(url)
                        }
                        showingPhotoAlbum = false
                    } else {
                        appData.showingDoneScreen = false
                    }
                    
                    #endif
                } label: {
                    #if os(macOS)
                    Text("Done!")
                    #else
                    if showingPhotoAlbum {
                        Text("Go to Photo Album!")
                    } else {
                        Text("Done!")
                    }
                    
                    #endif
                }
                .buttonStyle(StandardButton())
                .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.05)
                Spacer()
                Image("Logo_Transparent")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3)
            }
            .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color("DarkGray"))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white, lineWidth: 2)
            )
            .scaleEffect(scale)
            .onAppear {
                //counter += 1
                let baseAnimation = Animation.easeInOut(duration: 0.5)
                
                withAnimation(baseAnimation) {
                    scale = 1.0
                }
            }
            .reviewCounter()
        }
    }
}

// MARK: - Image Size View (Not being used - too much work to get the view right)
struct ImageSizeView: View {
    @EnvironmentObject var appData: AppData
    @StateObject var imageOptions = ImageOptions()
    @State var imageSize: String = "Advanced"
    @State var customWidth: String = ""
    @State var customHeight: String = ""
    @State var advancedSize: String = "180 x 180"
    @State var outputSize: CGPoint = CGPoint(x: 0, y: 0)
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 10){
                Spacer()
                Banner(title: "Save Options", subTitle: "Choose size of saved image!")
                Spacer()
                // Image Size Selection
                Picker("Image Size", selection: $imageSize) {
                    ForEach(imageOptions.optionsList, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle()
                .frame(width: geometry.size.width * 0.75)
                // Advanced
                if imageSize == "Advanced" {
                    Picker("Common Sizes", selection: $advancedSize) {
                        ForEach(imageOptions.advancedOptionsList, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle()
                    .frame(width: geometry.size.width * 0.75)
                }
                // Custom Height
                if imageSize == "Custom" {
                    VStack (spacing: 10){
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.left.and.right.square")
                            TextField("", text: self.$customWidth)
                                .modifier(PlaceholderStyle(showPlaceHolder: customWidth.isEmpty,
                                                           placeholder: "Custom Width (Example: 750"))
                        }
                        .frame(width: geometry.size.width * 0.75)
                        .modifier(StandardTextStyle())
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.up.and.down.square")
                            TextField("",text: self.$customHeight)
                                .modifier(PlaceholderStyle(showPlaceHolder: customHeight.isEmpty,
                                                           placeholder: "Custom Height (Example: 750"))
                        }
                        .frame(width: geometry.size.width * 0.75)
                        .modifier(StandardTextStyle())
                    }
                }
                
                
                Spacer()
                Button {
                    print("Custom Width: \(customWidth) | Custom Height: \(customHeight)")
                    switch imageSize {
                    case "Small":
                        outputSize = CGPoint(x: 200, y: 200)
                    case "Medium":
                        outputSize = CGPoint(x: 500, y: 500)
                    case "Large":
                        outputSize = CGPoint(x: 1000, y: 1000)
                    case "Advanced":
                        switch advancedSize {
                        case "180 x 180":
                            outputSize = CGPoint(x: 180, y: 180)
                        case "360 x 360":
                            outputSize = CGPoint(x: 360, y: 360)
                        case "720 x 720":
                            outputSize = CGPoint(x: 720, y: 720)
                        case "2048 x 2048":
                            outputSize = CGPoint(x: 2048, y: 2048)
                        default:
                            outputSize = CGPoint(x: 180, y: 180)
                        }
                    case "Custom":
                        outputSize = CGPoint(x: Int(self.customWidth) ?? 500, y: Int(self.customHeight) ?? 500)
                    default:
                        outputSize = CGPoint(x: 500, y: 500)
                    }
                    print("Output Size: \(outputSize)")
                    appData.outputImageSize = outputSize
                    appData.showingSizeOptions = false
#if os(macOS)
                    func saveImage() {
                        let path = appData.showSavePanel()
                        appData.outputImage = ImageSaveView(
                            width: appData.outputImageSize.x,
                            height: appData.outputImageSize.y
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
#endif
                } label: {
                    Text("Save")
                }
                .buttonStyle(StandardButton())
                .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.08)
                Spacer()
            }
            .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
            .background(Color("DarkGray"))
        }
    }
}

public struct PlaceholderStyle: ViewModifier {
    var showPlaceHolder: Bool
    var placeholder: String
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder)
                    .padding(.horizontal, 15)
            }
            content
                .foregroundColor(Color.white)
                .padding(5.0)
        }
    }
}

struct StandardTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
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
    }
}
class ImageOptions: ObservableObject {
    //@Published var selectedImageSize: ImageSizeOptions = ImageSizeOptions(name: "Medium", size: CGPoint(x: 500, y: 500))
    let imageOptionsList: [ImageSizeOptions] = [
        ImageSizeOptions(name: "Small", size: CGPoint(x: 200, y: 200)),
        ImageSizeOptions(name: "Medium", size: CGPoint(x: 500, y: 500)),
        ImageSizeOptions(name: "Large", size: CGPoint(x: 1000, y: 1000))
    ]
    
    let optionsList = ["Small", "Medium", "Large", "Advanced", "Custom"]
    let advancedOptionsList = ["180 x 180", "360 x 360", "720 x 720", "2048 x 2048"]
}
struct ImageSizeOptions: Identifiable {
    let id = UUID()
    let name: String
    let size: CGPoint
}

struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert()
            .environmentObject(AppData())
    }
}
