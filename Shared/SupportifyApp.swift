//
//  SupportifyApp.swift
//  Shared
//
//  Created by Kevin Cooper on 8/19/22.
//

import SwiftUI

@main
struct SupportifyApp: App {
    @StateObject var appData = AppData()
    @StateObject var navData = NavData()
   
    var body: some Scene {
        WindowGroup {
            ViewRouter()
                .environmentObject(appData)
                .environmentObject(navData)
        }
    }
}
