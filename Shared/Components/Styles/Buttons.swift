//
//  Buttons.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/25/22.
//

import SwiftUI

struct StandardButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            return configuration.label
                .padding(4)
                .frame(width: geometry.size.width, height: geometry.size.height)
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
                .opacity(configuration.isPressed ? 0.7 : 1)
                .scaleEffect(configuration.isPressed ? 0.8 : 1)
        }
    }
}

struct FlagButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            return configuration.label
                .padding(4)
                .frame(width: geometry.size.height * 0.25, height: geometry.size.height * 0.25)
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
                .opacity(configuration.isPressed ? 0.7 : 1)
                .scaleEffect(configuration.isPressed ? 0.8 : 1)
        }
    }
}
