//
//  ArticlePresenter.swift
//  NewsMobileApp
//
//  Created by Bhara Alfhaniawan on 22/07/24.
//

import Foundation

enum DataFetchPhase<T>{
    case empty
    case success(T)
    case error(Error)
    case fetchingNextPage(T)
    var value: T?{
        if case .success(let value) = self{
            return value
        } else if case .fetchingNextPage(let value) = self {
            return value
        } else {
            return nil
        }
    }
}

protocol ArticlePresenterProtocol{
    func loadFirstPage() async
    func searchArticle() async
}

@MainActor
class ArticlePresenter: ArticlePresenterProtocol, ObservableObject {
    @Published var phase = DataFetchPhase<[ArticleEntity]>.empty
    @Published var selectedCategory: Category
    @Published var searchQuery = ""

    private let articleInteractor = ArticleInteractor.shared
    private let pagingData = PagingEntity(itemsPerPage: 5, maxPageLimit: 500)
    
   
    var articles: [ArticleEntity] {
        return phase.value ?? []
    }

    var isFetchingNextPage: Bool {
        if case .fetchingNextPage = phase {
            return true
        }
        return false
    }

    init(articles: [ArticleEntity]? = nil, selectedCategory: Category = .general) {
        if let articles = articles {
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
        self.selectedCategory = selectedCategory
    }

    func loadFirstPage() async {
        phase = .empty
        do {
            await pagingData.reset()
            let articles = try await pagingData.loadNextPage(dataFetchProvider: loadArticle(page:))
            if Task.isCancelled { return }
            phase = .success(articles)
        } catch {
            if (error as NSError).code != NSURLErrorCancelled {
                phase = .error(error)
            }
        }
    }

    func loadNextPage() async {
        if Task.isCancelled { return }
        
        let currentArticles = self.phase.value ?? []
        phase = .fetchingNextPage(currentArticles)
        
        do {
            let nextArticles = try await pagingData.loadNextPage(dataFetchProvider: loadArticle(page:))
            if Task.isCancelled { return }
            phase = .success(currentArticles + nextArticles)
        } catch {
            if (error as NSError).code != NSURLErrorCancelled {
                phase = .error(error)
            }
        }
    }

    private func loadArticle(page: Int) async throws -> [ArticleEntity] {
        let articles = try await articleInteractor.fetchNews(
            from: selectedCategory, pageSize: pagingData.itemsPerPage, page: page)
        return articles
    }

    func searchArticle() async {
        let searchQuery = self.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        phase = .empty
        
        if searchQuery.isEmpty { return }
        
        do {
            let articles = try await articleInteractor.fetchNews(query: searchQuery)
            if Task.isCancelled { return }
            phase = .success(articles)
        } catch {
            if (error as NSError).code != NSURLErrorCancelled {
                phase = .error(error)
            }
        }
    }
}
