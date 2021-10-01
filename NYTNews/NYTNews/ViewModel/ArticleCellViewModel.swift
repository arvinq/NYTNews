//
//  ArticleCellViewModel.swift
//  NYTNews
//
//  Created by Arvin on 30/9/21.
//

import Foundation

struct ArticleCellViewModel: Hashable {
    let slugName: String
    let title: String
    let abstract: String
    let thumbnailStandard: String
    
    init(article: Article) {
        self.slugName = article.slugName
        self.title = article.title ?? ""
        self.abstract = article.abstract ?? ""
        self.thumbnailStandard = article.thumbnailStandard ?? ""
    }
}
