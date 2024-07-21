//
//  ArticleSingleView.swift
//  NewsMobileApp
//
//  Created by Bhara Alfhaniawan on 22/07/24.
//

import SwiftUI

struct ArticleSingleView: View {
    let article: ArticleEntity
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: article.imageURL) {
                phase in
                switch phase {
                case .empty:
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(_):
                    HStack {
                        Spacer()
                        Image(systemName: "photo")
                        Spacer()
                    }
                @unknown default:
                    fatalError()
                }
            }
            .frame(minHeight: 200, maxHeight: 200)
            .background(Color.gray.opacity(0.3))
            .clipped()
            
            VStack(alignment: .leading, spacing: 7) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(3)
                
                Text(article.descriptionText)
                    .font(.subheadline)
                    .lineLimit(2)
                
                HStack {
                    Text(article.captionText)
                        .font(.caption)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            .padding([.bottom, .horizontal])
            Spacer()
        }
    }
}

#Preview {
    NavigationView{
        List{
            ArticleSingleView(article: .previewData[0])
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.plain)
    }
}
