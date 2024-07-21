//
//  APIResponse.swift
//  NewsMobileApp
//
//  Created by Bhara Alfhaniawan on 22/07/24.
//

import Foundation

struct APIResponse: Decodable {
    
    let status: String
    let totalResults: Int?
    let articles: [ArticleEntity]?
    
    let code: String?
    let message: String?
    
}
