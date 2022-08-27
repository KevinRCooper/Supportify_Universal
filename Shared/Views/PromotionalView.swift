//
//  PromotionalView.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/26/22.
//

import SwiftUI

struct PromotionalView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .center){
                Banner(title: "Show your LGBTQ+ support!")
                Spacer()
                ImageOverlayWrapper()
                    .frame(width: (geometry.size.width < geometry.size.height ? geometry.size.width * 0.8 : geometry.size.height * 0.6), height: (geometry.size.width < geometry.size.height ? geometry.size.width * 0.8 : geometry.size.height * 0.6))
                Spacer()
                Banner(subTitle: "Customize your profile photo")
            }
            .padding(50)
            .appBackground()
            .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
        }
        
    }
}

//// Flag List
//@Published var flagsList : [Flags] = [
//    Flags(id: 0,
//          name: NSLocalizedString("Gilbert Pride Flag", comment: ""),
//          image: "Gilbert_Pride_Flag",
//          selected: false
//         ),
//    Flags(id: 1,
//          name: NSLocalizedString("6-Color Pride Flag", comment: ""),
//          image: "6-Color_Pride_Flag",
//          selected: true
//         ),
//    Flags(id: 2,
//          name: NSLocalizedString("Philadelphia Pride Flag", comment: ""),
//          image: "Philadelphia_Pride_Flag",
//          selected: false
//         ),
//    Flags(id: 3,
//          name: NSLocalizedString("Transgender Pride Flag", comment: ""),
//          image: "Transgender_Pride_Flag",
//          selected: false
//         ),
//    Flags(id: 4,
//          name: NSLocalizedString("Progress Pride Flag", comment: ""),
//          image: "Progress_Pride_Flag",
//          selected: false
//         )
//]

struct PromotionalView2: View {
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .center){
                Banner(title: "Select from a range of pride colors!")
                Spacer()
                VStack {
                    HStack (spacing: 50){
                        VStack {
                            Image("Gilbert_Pride_Flag")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                            Text("Gilbert Pride Flag")
                                .font(Font.title.weight(.bold))
                                .foregroundColor(.white)
                        }
                        VStack {
                            Image("6-Color_Pride_Flag")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                            Text("6 Color Pride Flag")
                                .font(Font.title.weight(.bold))
                                .foregroundColor(.white)
                        }
                        VStack {
                            Image("Philadelphia_Pride_Flag")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                            Text("Philadelphia Pride Flag")
                                .font(Font.title.weight(.bold))
                                .foregroundColor(.white)
                        }
                        
                    }
                    HStack (spacing: 50){
                        VStack {
                            Image("Transgender_Pride_Flag")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                            Text("Transgender Pride Flag")
                                .font(Font.title.weight(.bold))
                                .foregroundColor(.white)
                        }
                        VStack {
                            Image("Progress_Pride_Flag")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                            Text("Progress Pride Flag")
                                .font(Font.title.weight(.bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                
                Spacer()
                Banner(subTitle: "")
            }
            .padding(50)
            .appBackground()
            .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
        }
        
    }
}

struct PromotionalView_Previews: PreviewProvider {
    static var previews: some View {
        PromotionalView()
            .environmentObject(AppData())
    }
}
