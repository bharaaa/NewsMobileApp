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
    let webViewPresenter = SafariViewPresenter()
    var isFetching = false
    var nextPageHandler: (() async -> ())? = nil
    
    var body: some View {
        List {
            ForEach(articles) { article in
                if let nextPageHandler = nextPageHandler, article == articles.last{
                    ArticleSingleView(article: article)
                        .onTapGesture {
                            selectedArticle = article
                        }
                        .task {
                            await nextPageHandler()
                        }
                    if isFetching{
                        HStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                } else{
                    ArticleSingleView(article: article)
                        .onTapGesture {
                            selectedArticle = article
                        }
                }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.plain)
        .sheet(item: $selectedArticle) {
            SafariView(url: $0.articleURL)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    ArticleListView(articles: ArticleEntity.previewData)
}
