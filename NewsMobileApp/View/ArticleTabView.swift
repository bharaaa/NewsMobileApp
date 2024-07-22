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
                articles: articlePresenter.articles,
                isFetching: articlePresenter.isFetchingNextPage,
                nextPageHandler: { await articlePresenter.loadNextPage() }
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
            .onChange(of: articlePresenter.selectedCategory) {
                Task {
                    await articlePresenter.loadFirstPage()
                }
            }
            .onChange(of: articlePresenter.searchQuery) {
                if articlePresenter.searchQuery.isEmpty {
                    Task {
                        await articlePresenter.loadFirstPage()
                    }
                } else {
                    Task {
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
            NoNewsView() {
                Task {
                    await articlePresenter.loadFirstPage()
                }
            }
        case .error(let error):
            NoInternetView(text: error.localizedDescription) {
                Task {
                    await articlePresenter.loadFirstPage()
                }
            }
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
            Image(systemName: "list.bullet")
                .imageScale(.large)
        }
    }
}

#Preview {
    ArticleTabView()
}
