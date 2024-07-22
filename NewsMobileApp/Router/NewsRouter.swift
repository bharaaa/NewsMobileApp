//
//  NewsRouter.swift
//  NewsMobileApp
//
//  Created by Bhara Alfhaniawan on 22/07/24.
//

import Foundation
import SwiftUI

protocol AppRouter {
    func start()
}

class NewsRouterImplementation: AppRouter, ObservableObject {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    @MainActor
    func start() {
        let presenter = ArticlePresenter()
        let mainView = ArticleTabView(articlePresenter: presenter)
        
        let rootViewController = UIHostingController(rootView: mainView)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
