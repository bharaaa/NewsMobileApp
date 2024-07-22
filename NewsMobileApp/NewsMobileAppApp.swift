//
//  NewsMobileAppApp.swift
//  NewsMobileApp
//
//  Created by Bhara Alfhaniawan on 21/07/24.
//

import SwiftUI

@main
struct NewsMobileAppApp: App {
    @StateObject var router = NewsRouterImplementation(window: UIWindow())
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
                .onAppear {
                    router.start()
                }
        }
    }
}
