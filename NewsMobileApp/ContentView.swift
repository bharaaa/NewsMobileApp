//
//  ContentView.swift
//  NewsMobileApp
//
//  Created by Bhara Alfhaniawan on 21/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ArticleTabView()
            .tabItem{
                Label("News", systemImage: "newspaper")
            }
    }
}

#Preview {
    ContentView()
}
