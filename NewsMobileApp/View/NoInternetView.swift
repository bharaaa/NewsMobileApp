//
//  NoInternetView.swift
//  NewsMobileApp
//
//  Created by Bhara Alfhaniawan on 22/07/24.
//

import SwiftUI

struct NoInternetView: View {
    let text: String
    let retryAction: ()-> ()
    
    var body: some View {
        VStack {
            Image(systemName: "wifi.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
            
            Text("No Internet Connection")
                .font(.headline)
                .padding(.top, 16)
            Text("Please check your internet connection and try again.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
                .padding(.horizontal, 30)
            
            Button(action: retryAction) {
                Text("Retry")
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
    NoInternetView(text: "an error occured") {
        
    }
}
