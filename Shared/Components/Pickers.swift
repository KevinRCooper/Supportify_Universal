//
//  PIckers.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/22/22.
//


import SwiftUI

#if os(macOS)
// MARK: - Styles the Pickers
struct PickerModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .pickerStyle(SegmentedPickerStyle())
            .padding(10)
            //.colorMultiply(.green)//.colorInvert()
            //.colorMultiply(.white).colorInvert()
            .background(Color("prideOrange"))
            .cornerRadius(16)
            .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 4)
                )
            //.padding(.horizontal, horizontalSizeClass == .compact ? 20 : 150)
    }
}
#else
// MARK: - Styles the Pickers
struct PickerModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    init() {
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .subheadline)], for: .normal)
    }
    func body(content: Content) -> some View {
        content
            .pickerStyle(SegmentedPickerStyle())
            .padding(10)
            .colorMultiply(.green)//.colorInvert()
            .colorMultiply(.white).colorInvert()
            .background(Color("prideOrange"))
            .font(.title3)
            .minimumScaleFactor(0.0001)
            .lineLimit(1)
            .cornerRadius(16)
            .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 4)
                )
            //.padding(.horizontal, horizontalSizeClass == .compact ? 20 : 150)
    }
}
#endif
// Todo: Make width match the other pickers.
extension HStack {
    func optionsSelection(extraPadding: Bool) -> some View {
        
        self
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .foregroundColor(.white)
            //.font(.subheadline)
            .font(.title3)
            .minimumScaleFactor(0.0001)
            .lineLimit(1)
            #if !os(macOS)
            .colorMultiply(.green)//.colorInvert()
            .colorMultiply(.white).colorInvert()
            #endif
            .background(Color("prideOrange"))
            .cornerRadius(16)
            .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 4)
                )
            .padding(.horizontal, extraPadding ? 150 : 0)
    }
}

extension View {
    func pickerStyle() -> some View {
        modifier(PickerModifier())
    }
    
//    func addPaddingSaveImage() -> some View {
//        modifier(AddPaddingSaveImage())
//    }
}

