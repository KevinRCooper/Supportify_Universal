//
//  Device.swift
//  Supportify (iOS)
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI

extension UIDevice {
    static var idiom: UIUserInterfaceIdiom {
        UIDevice.current.userInterfaceIdiom
    }
    static var isIpad: Bool {
        idiom == .pad
    }
    
    static var isiPhone: Bool {
        idiom == .phone
    }
}

