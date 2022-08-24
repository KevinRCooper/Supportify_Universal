//
//  ScreenSizing.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/24/22.
//

import SwiftUI

class SGConvenience{
    #if os(watchOS)
    static var deviceWidth:CGFloat = WKInterfaceDevice.current().screenBounds.size.width
    static var deviceHeight:CGFloat = WKInterfaceDevice.current().screenBounds.size.height
    #elseif os(iOS)
    static var deviceWidth:CGFloat = UIScreen.main.bounds.size.width
    static var deviceHeight:CGFloat = UIScreen.main.bounds.size.height
    #elseif os(macOS)
    static var deviceWidth:CGFloat? = NSScreen.main?.visibleFrame.size.width // You could implement this to force a CGFloat and get the full device screen size width regardless of the window size with
    static var deviceHeight:CGFloat? = NSScreen.main?.visibleFrame.size.height
    #endif
}
