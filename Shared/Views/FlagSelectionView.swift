//
//  FlagSelectionView.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI

struct FlagSelectionView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var navData: NavData

    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .center){
                Spacer()
                    .frame(height: geometry.size.height * 0.05)
                // Banner
                VStack {
                    Banner(title: "Flag Selection", subTitle: "Choose an LGBTQ+ Flag!")
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                // Flag List
                Spacer()
                #if os(macOS)
                Spacer()
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: geometry.size.width * 0.25))
                    ], spacing: 30) {
                        ForEach(appData.flagsList) { flag in
                            Button {
                                appData.selectedFlagName = flag.name
                            } label: {
                                VStack {
                                    Image(flag.image)
                                        .resizable()
                                        .scaledToFill()
                                    Text(flag.name)
                                }
                            }
                            .frame(width: geometry.size.height * 0.35, height: geometry.size.height * 0.25)
                            .buttonStyle(PlainButtonStyle())
                            .foregroundColor(.white)
                            .font(.title)
                            .minimumScaleFactor(0.0001)
                            .lineLimit(1)
                            .opacity(appData.selectedFlagName == flag.name ? 1.0 : 0.5)
                        }
                        
                    }
                }
                #else
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: geometry.size.height * 0.35))
                    ], spacing: 20) {
                        ForEach(appData.flagsList) { flag in
                                Button {
                                    appData.selectedFlagName = flag.name
                                    Haptics.shared.play(.medium)
                                } label: {
                                    ZStack {
                                        Image(flag.image)
                                            .resizable()
                                            .scaledToFill()
                                            
                                        Text(flag.name)
                                            .background(Color.gray)
                                            .opacity(0.8)
                                            .cornerRadius(10.0)
                                            .foregroundColor(.white)
                                        
                                    }
                                    .frame(width: geometry.size.height * 0.35, height: geometry.size.height * 0.25)
                                }
                                .foregroundColor(.white)
                                .font(.title2)
                                .minimumScaleFactor(0.0001)
                                .lineLimit(1)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(appData.selectedFlagName == flag.name ? .green : .white, lineWidth: 10)
                                )
                                .opacity(appData.selectedFlagName == flag.name ? 1.0 : 0.5)
                            
                        }
                    }
                }
                .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.6)
                #endif
                Spacer()
                Button {
                    navData.navigationSelection = "Image Overlay"
                    Haptics.shared.play(.medium)
                    //appData.hasImageBeenSelected = false
                } label: {
                    Text("Image Overlay \(Image(systemName: "person.circle"))")
                }
                .buttonStyle(StandardButton())
                .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.05)
                Spacer()
            }
            
            Spacer()
        }
        .appBackground()
    }
}

struct FlagSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        FlagSelectionView()
            .environmentObject(AppData())
            .environmentObject(NavData())
    }
}
