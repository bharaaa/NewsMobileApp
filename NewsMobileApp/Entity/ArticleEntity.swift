//
//  ArticleEntity.swift
//  NewsMobileApp
//
//  Created by Bhara Alfhaniawan on 22/07/24.
//

import Foundation

fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()

struct ArticleEntity {
    let id = UUID()
    
    let source: Source
    
    let title: String
    let url: String
    let publishedAt: Date
    
    let author: String?
    let description: String?
    let urlToImage: String?
    
    enum CodingKeys: String, CodingKey {
        case source
        case title
        case url
        case publishedAt
        case author
        case description
        case urlToImage
    }
    
    var authorText: String {
        author ?? ""
    }
    
    var descriptionText: String {
        description ?? ""
    }
    
    var captionText: String {
        "\(source.name) ‧ \(relativeDateFormatter.localizedString(for: publishedAt, relativeTo: Date()))"
    }
    
    var articleURL: URL {
        URL(string: url)!
    }
    
    var imageURL: URL? {
        guard let urlToImage = urlToImage else {
            return nil
        }
        return URL(string: urlToImage)
    }
}

extension ArticleEntity: Codable {}
extension ArticleEntity: Equatable {}
extension ArticleEntity: Identifiable {}

extension ArticleEntity {
    
    static var previewData: [ArticleEntity] {
        let previewDataURL = Bundle.main.url(forResource: "newslist", withExtension: "json")!
        print(previewDataURL)
        let data = try! Data(contentsOf: previewDataURL)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        let apiResponse = try! jsonDecoder.decode(APIResponse.self, from: data)
        return apiResponse.articles ?? []
    }
    
}

struct Source {
    let name: String
}

extension Source: Codable {}
extension Source: Equatable {}
