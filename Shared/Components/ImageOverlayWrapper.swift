//
//  ImageOverlayWrapper.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI

struct ImageOverlayWrapper: View {
    @EnvironmentObject var appData: AppData
    @GestureState var fingerLocation: CGPoint? = nil
    @GestureState var startLocation: CGPoint? = nil
    @GestureState var magnifyBy = 1.0
    @State private var lastScale: Double = 1.0
    
    // Pinch Zoom
    var magnification: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { currentState, gestureState, transaction in
                gestureState = currentState
            }
            .onEnded { value in
                print("Ending Value: \(value)")
                appData.zoomLevel *= value
            }
    }
    
    // Image Drag Handling
    var simpleDrag: some Gesture {
        DragGesture(coordinateSpace: .local)
            .onChanged { value in
                //var newLocation = startLocation ?? appData.location
                //var newLocation = startLocation ?? (appData.location ?? CGPoint(x: 250, y: 250))
                var newLocation = startLocation ?? (appData.location ?? (fingerLocation ?? CGPoint(x: 250, y: 250)))
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                appData.location = newLocation
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? appData.location
            }
    }
    
    // Finger Position for Drag
    var fingerDrag: some Gesture {
        DragGesture()
            .updating($fingerLocation) { (value, fingerLocation, transaction) in
                fingerLocation = value.location
            }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                #if os(macOS)
                if appData.inputImage != nil {
                    ZStack {
                        Image(nsImage: appData.inputImage!)
                            .resizable()
                            .scaledToFill()
                            .scaleEffect(appData.zoomLevel)
                            .position(appData.location ?? CGPoint(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5))
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .fixedSize()
                            .clipShape(Circle())
                    }
                    .contentShape(Circle())
                    .gesture(simpleDrag)
                    
                } else {
                    ZStack {
                        Image("Logo_Transparent")
                            .resizable()
                            .scaledToFill()
                            .scaleEffect(appData.zoomLevel)
                            .position(appData.location ?? CGPoint(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5))
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .fixedSize()
                            .clipShape(Circle())
                            .onChange(of: geometry.size) { _ in
                                appData.location = CGPoint(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
                            }
                    }
                    .contentShape(Circle())
                    .gesture(MagnificationGesture())
                    .simultaneousGesture(simpleDrag)
                    //.gesture(simpleDrag)
                    
                }
                    
                #else
                ZStack {
                    Image(uiImage: (appData.selectedImage != nil ? appData.selectedImage : UIImage(named: "Logo_Transparent"))!)
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(appData.zoomLevel)
                        .position(appData.location ?? CGPoint(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5))
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .fixedSize()
                        .clipShape(Circle())
                        .onChange(of: geometry.size) { _ in
                            appData.location = CGPoint(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
                        }
                }
                .contentShape(Circle())
                .gesture(MagnificationGesture()
                    .onChanged { val in
                        let delta = val / appData.zoomLevel
                        self.lastScale = val
                        let newScale = appData.zoomLevel * delta
                        appData.zoomLevel = newScale
                    }
                    .onEnded { val in
                        appData.zoomLevel = val
                    }
                )
                .simultaneousGesture(simpleDrag)
                //.gesture(simpleDrag)
                
                #endif
                if appData.imageDisplay == "Banner" && appData.userSeenOverlayScreen{
                    prideFlagOverlay(width: geometry.size.width)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.2)
                        .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.9)
                        .clipShape(Circle())
                    TextDisplay()
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.1)
                        .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.89)
                }
                // Circle Border
                if appData.imageDisplay == "Circle Gradient" {
                    Circle()
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: appData.getPrideFlagColors(selection: appData.selectedFlagName, type: "gradient")),
                            center: .center,
                            startAngle: .degrees(360),
                            endAngle: .degrees(0)
                        )
                        , style: StrokeStyle(lineWidth: CGFloat(appData.imageDisplayLineWidth), lineCap: .round))
                } else {
                    Circle()
                        .stroke(lineWidth: 5.0)
                        .foregroundColor(.white)
                }
                
            }
        }
    }
}

// MARK: - Pride Flag Overlay
struct prideFlagOverlay: View {
    @EnvironmentObject var appData: AppData
    @State var width: CGFloat = CGFloat(100)
    var body: some View {
        if appData.imageDisplay == "Banner" {
            GeometryReader { geometry in
                HStack (spacing: 0){
                    ForEach(appData.getPrideFlagColors(selection: appData.selectedFlagName, type:"banner"), id : \.self) { namedColor in
                        Rectangle()
                            .fill(namedColor)
                            .frame(width: colorCount(appData: appData, width: width))
                    }
                    
                }
                .frame(width: geometry.size.width)
            }
        }
        
    }
}

// MARK: - Custom function to set width of Pride Banner Colors Overlay
func colorCount(appData: AppData, width: CGFloat) -> CGFloat {
    let width = width
    let appData = appData
    let colorArray = appData.getPrideFlagColors(selection: appData.selectedFlagName, type: "")
    let count = colorArray.count
    let newWidth = ((Float(100) / Float(count)) / Float(100))
    return (CGFloat(width) * CGFloat(newWidth)) - 7
}

struct TextDisplay: View {
    @EnvironmentObject var appData: AppData
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                ZStack {
                    Text(appData.communityIdentification)
                        .foregroundColor(.white)
                        .font(.system(size: 500))
                        .minimumScaleFactor(0.02)
                        .lineLimit(1)
                }
                .background(Color.gray)
                .opacity(0.8)
                .cornerRadius(10.0)
                .padding(0)
                Spacer()
            }
        }
    }
}

struct ImageOverlayWrapper_Previews: PreviewProvider {
    static var previews: some View {
        ImageOverlayWrapper()
            .environmentObject(AppData())
    }
}
