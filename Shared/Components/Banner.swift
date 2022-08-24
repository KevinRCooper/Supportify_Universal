//
//  Banner.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI

struct Banner: View {
    @State var title: String?
    @State var subTitle: String?
    var body: some View {
            VStack {
                if title != nil {
                    Text(title ?? "Supportify")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .minimumScaleFactor(0.01)
                }
                if subTitle != nil {
                    Text(subTitle ?? "Show your support for the LGBTQ+ Community!")
                        .font(.largeTitle)
                        .minimumScaleFactor(0.01)
                        .foregroundColor(Color(hue: 1.0, saturation: 0.061, brightness: 0.839))
                        .lineLimit(1)
                }
            }
    }
}
