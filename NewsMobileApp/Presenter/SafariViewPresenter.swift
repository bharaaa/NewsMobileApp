//
//  SafariViewPresenter.swift
//  NewsMobileApp
//
//  Created by Bhara Alfhaniawan on 22/07/24.
//

import Foundation

class SafariViewPresenter{
    func presentWebView(url:URL)->SafariView{
        return SafariView(url: url)
    }
}
