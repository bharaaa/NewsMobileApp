//
//  ArticleInteractor.swift
//  NewsMobileApp
//
//  Created by Bhara Alfhaniawan on 22/07/24.
//

import Foundation

struct ArticleInteractor {

    static let shared = ArticleInteractor()
    private init() {}

    private let apiKey = "bc95601ebacd4307b99852caecb24563"
    private let session = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    func fetchNews(from category: Category? = nil, query: String? = nil, pageSize: Int=5, page: Int=1) async throws -> [ArticleEntity] {
        let url: URL
        if let category = category {
            url = generateNewsUrl(from: category, pageSize: pageSize, page: page)
        } else if let query = query {
            url = generateSearchUrl(from: query, pageSize: pageSize, page: page)
        } else {
            throw generateError(description: "error")
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw generateError(description: "An Error occured")
        }

        switch httpResponse.statusCode {
        case 200...299, 400...499:
            let apiResponse = try jsonDecoder.decode(APIResponse.self, from: data)
            if apiResponse.status == "ok" {
                return apiResponse.articles ?? []
            } else {
                throw generateError(description:  apiResponse.message ?? "An error occurred")
            }
        default:
            throw generateError(description: "An error occured")
        }
    }

    private func generateError(code: Int = 1, description: String) -> Error {
        NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }

    private func generateSearchUrl(from query: String, pageSize: Int=5, page: Int=1) -> URL{
        let queryFormatting = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query

        let url = "https://newsapi.org/v2/everything?apiKey=\(apiKey)&language=en&q=\(queryFormatting)&page=\(page)&pageSize=\(pageSize)"

        return URL(string: url)!
    }

    private func generateNewsUrl(from category: Category, pageSize: Int=5, page: Int=1) -> URL {
        let url = "https://newsapi.org/v2/top-headlines?apiKey=\(apiKey)&language=en&category=\(category.rawValue)&page=\(page)&pageSize=\(pageSize)"
        return URL(string: url)!
    }
}
