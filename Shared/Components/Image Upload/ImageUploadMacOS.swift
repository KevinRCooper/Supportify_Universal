//
//  ImageUploadMacOS.swift
//  Supportify (macOS)
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI
import Foundation
class MacOSImageHandling: ObservableObject {
    static var shared = MacOSImageHandling()
    @Published var inputUrl: URL?
    @Published var outputUrl: String?
    @Published var inputImage: NSImage?
    @Published var outputImage: NSImage?
    
}

extension View {
    func snapshot() -> NSImage? {
        let controller = NSHostingController(rootView: self)
        let targetSize = controller.view.intrinsicContentSize
        print(targetSize)
        //let targetSize = CGRect()
        let contentRect = NSRect(origin: .zero, size: targetSize)
        
        let window = NSWindow(
            contentRect: contentRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.contentView = controller.view
        
        guard
            let bitmapRep = controller.view.bitmapImageRepForCachingDisplay(in: contentRect)
        else { return nil }
        
        controller.view.cacheDisplay(in: contentRect, to: bitmapRep)
        let image = NSImage(size: bitmapRep.size)
        image.addRepresentation(bitmapRep)
        return image
    }
}
