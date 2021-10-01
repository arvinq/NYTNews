//
//  ArticleInfoViewModel.swift
//  NYTNews
//
//  Created by Arvin on 1/10/21.
//

import Foundation

struct ArticleInfoViewModel: Hashable {
    let slugName: String
    let title: String
    let abstract: String
    let thumbnailStandard: String
    let url: String
    let byline: String
    let publishedDate: String
    
    init(article: Article) {
        self.slugName = article.slugName
        self.title = article.title ?? ""
        self.abstract = article.abstract ?? ""
        self.thumbnailStandard = article.thumbnailStandard ?? ""
        self.url = article.url ?? ""
        self.byline = article.byline ?? ""
        self.publishedDate = article.publishedDate ?? ""
    }
}

