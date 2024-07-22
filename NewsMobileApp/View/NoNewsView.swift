//
//  NoNewsView.swift
//  NewsMobileApp
//
//  Created by Bhara Alfhaniawan on 22/07/24.
//

import SwiftUI

struct NoNewsView: View {
    let retryAction: ()-> ()
    
    var body: some View {
        VStack {
            Image(systemName: "doc.text.magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
            
            Text("No Articles Available")
                .font(.headline)
                .padding(.top, 16)
            Text("Please check back later for the latest articles.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
                .padding(.horizontal, 20)
            
            Button(action: retryAction) {
                Text("Refresh")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 24)
        }
        .padding()
    }
}

#Preview {
    NoNewsView() {
        
    }
}
