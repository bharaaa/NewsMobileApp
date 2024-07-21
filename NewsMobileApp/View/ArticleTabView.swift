//
//  ArticleTabView.swift
//  NewsMobileApp
//
//  Created by Bhara Alfhaniawan on 22/07/24.
//

import SwiftUI

struct ArticleTabView: View {
    @StateObject var articlePresenter = ArticlePresenter()

    var body: some View {
        NavigationStack {
            ArticleListView(
                articles: articlePresenter.articles
//                isFetching: articlePresenter.isFetchingNextPage,
//                nextPageHandler: { await articlePresenter.loadNextPage() }
            )
            .overlay(overlayView)
            .refreshable {
                Task {
                    await articlePresenter.loadFirstPage()
                }
            }
            .onAppear {
                Task {
                    await articlePresenter.loadFirstPage()
                }
            }
            .navigationTitle(articlePresenter.selectedCategory.text)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    menu
                }
            }
            .onChange(of: articlePresenter.selectedCategory) { _ in
                Task {
                    await articlePresenter.loadFirstPage()
                }
            }
            .onChange(of: articlePresenter.searchQuery){ newValue in
                if newValue.isEmpty{
                    Task{
                        await articlePresenter.loadFirstPage()
                    }
                    
                }else{
                    Task{
                        await articlePresenter.searchArticle()
                    }

                }
            }
            .searchable(text: $articlePresenter.searchQuery)
        }
    }

    @ViewBuilder
    private var overlayView: some View {
        switch articlePresenter.phase {
        case .empty:
            ProgressView()
        case .success(let articles) where articles.isEmpty:
            Text("No articles")
        case .error(let error):
            Text("Error")
        default:
            EmptyView()
        }
    }

    private var menu: some View {
        Menu {
            Picker("Category", selection: $articlePresenter.selectedCategory) {
                ForEach(Category.allCases) {
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "fiberchannel")
                .imageScale(.large)
        }
    }
}

#Preview {
    ArticleTabView()
}
