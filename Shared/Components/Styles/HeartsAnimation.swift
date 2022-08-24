//
//  HeartsAnimation.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/24/22.
//

import SwiftUI

struct HeartsAnimation: View {
    @State var animatedHeart = false
    @State private var hasTimeElapsed = false
    @State private var showingHome = false
    let newArray = [Int](1...40)

    var body: some View {
               
            ZStack {
                ForEach(newArray, id: \.self) { item in
                    HeartView(animatedHeart: animatedHeart)
                }
                .onAppear {self.animatedHeart.toggle()}
                .task(delayText)
                if hasTimeElapsed {
                    Text("Welcome")
                        .font(.system(size: (SGConvenience.deviceWidth ?? 1000) * 0.06))
                        .minimumScaleFactor(0.6)
                        //.fontWeight(.bold)
                        .foregroundColor(.white)
                        .transition(.opacity.animation(.easeIn(duration: 3)))
                        .padding(.bottom, 300)
                }
               
            }
    }
    @Sendable private func delayText() async {
            // Delay of 7.5 seconds (1 second = 1_000_000_000 nanoseconds)
            try? await Task.sleep(nanoseconds: 3_500_000_000)
            hasTimeElapsed = true
        }
}

struct HeartView: View {
    var animatedHeart : Bool

    let xPositionStart = (Int((SGConvenience.deviceWidth ?? 1000) - ((SGConvenience.deviceWidth ?? 1000) * 2))..<Int((SGConvenience.deviceWidth ?? 1000))).map{ CGFloat($0) }
    let yPositionStart = (SGConvenience.deviceHeight ?? 1000) - ((SGConvenience.deviceHeight ?? 1000) * 2)
    let randomAnimationDuration = Double.random(in: 0..<6)
    let angleStart = (0..<360).map{ CGFloat($0) }
    @StateObject var appData = AppData()
    
    var body: some View {
        Rectangle()
            .foregroundColor(appData.prideColors.randomElement())
            .frame(width: 250, height: 270, alignment: .center)
            .offset(y: -60)
            .mask(Image(systemName: "heart.fill")
                .resizable()
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
                .aspectRatio(contentMode: .fit)
                .rotation3DEffect(
                    Angle(degrees: self.animatedHeart ? angleStart.randomElement()! : 0),
                    axis: (x: 0, y: self.animatedHeart ? 360 : 0, z: 0)
                    
                )
            )
            .offset(x: xPositionStart.randomElement()!, y: self.animatedHeart ? 1500 : yPositionStart)
            .animation(.linear(duration: 3).delay(randomAnimationDuration))
        // 500 Normal, 720 iPad
    }
}

struct HeartsAnimation_Previews: PreviewProvider {
    static var previews: some View {
        HeartsAnimation()
    }
}
