//
//  NavData.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI

class NavData: ObservableObject {
    // Navigation Items
    let navigationItems: [NavItem] = [
        NavItem(name: NSLocalizedString("Home", comment: ""), image: "house"),
        NavItem(name: NSLocalizedString("Image Selection", comment: ""), image: "photo.on.rectangle.angled"),
        NavItem(name: NSLocalizedString("Flag Selection", comment: ""), image: "flag.fill"),
        NavItem(name: NSLocalizedString("Image Overlay", comment: ""), image: "person.circle"),
        NavItem(name: NSLocalizedString("Review", comment: ""), image: "square.and.arrow.down.fill"),
        //NavItem(name: NSLocalizedString("Promotional", comment: ""), image: "square.and.arrow.down.fill")
    ]
    @Published var navigationSelection: String = "Home"
}

struct NavItem: Identifiable {
    let id = UUID()
    let name: String
    let image: String
}

@ViewBuilder func navigationViewSelect(view: String) -> some View {
    switch view {
    case "Home":
        HomeView()
    case "Image Selection":
        ImageSelectView()
    case "Flag Selection":
        FlagSelectionView()
    case "Image Overlay":
        ImageOverlayView()
    case "Review":
        ReviewView()
    case "Promotional":
        PromotionalView()
    default:
        EmptyView()
    }
}
