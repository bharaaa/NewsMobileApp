//
//  ArticleListView.swift
//  NewsMobileApp
//
//  Created by Bhara Alfhaniawan on 22/07/24.
//

import SwiftUI

struct ArticleListView: View {
    let articles: [ArticleEntity]
    @State private var selectedArticle: ArticleEntity?
    
    var body: some View {
        List {
            ForEach(articles) { article in
                ArticleSingleView(article: article)
                    .onTapGesture {
                        selectedArticle = article
                    }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.plain)
    }
}

#Preview {
    ArticleListView(articles: ArticleEntity.previewData)
}
