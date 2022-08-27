//
//  ReviewHandler.swift
//  Supportify
//
//  Created by Kevin Cooper on 8/24/22.
//
// Review Code created by George Garside [(https://georgegarside.com/blog/ios/swiftui-skstorereviewcontroller-requestreview/)]

import Foundation
import StoreKit
import SwiftUI

/// `SKStoreReviewController.requestReview` after 3 `onAppear`-triggering appearances of the view.
struct ReviewCounter: ViewModifier {
    /// Counter of events that would lead to a review being asked for.
    @AppStorage("review.counter") private var reviewCounter = 0
    @AppStorage("review.version") private var reviewVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    @AppStorage("review.promptSeen") private var reviewPromptSeen = false

    func body(content: Content) -> some View {
        content
            .onAppear {
                if reviewPromptSeen {
                    reviewCounter = 0
                } else if reviewVersion == Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "" {
                    reviewCounter += 1
                    print("Current Review Count: \(reviewCounter)")
                } else {
                    reviewVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
                    reviewPromptSeen = false
                }
                
            }
            .onDisappear {
                if reviewCounter > 3 && !reviewPromptSeen{
                    reviewPromptSeen = true
                    reviewCounter = 0
                    DispatchQueue.main.async {
                        #if os(macOS)
                        SKStoreReviewController.requestReview()
                        #else
                        if let scene = UIApplication.shared.connectedScenes
                                .first(where: { $0.activationState == .foregroundActive })
                                as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                        #endif
                    }
                }
            }
    }
}

extension View {
    /// `SKStoreReviewController.requestReview` after 3 `onAppear`-triggering appearances of the view.
    func reviewCounter() -> some View {
        modifier(ReviewCounter())
    }
}
