//
//  Article.swift
//  NYTNews
//
//  Created by Arvin on 30/9/21.
//

import Foundation

struct Article: Codable {
    let slugName: String
    let title: String?
    let abstract: String? //sub
    let url: String?
    let byline: String?
    let thumbnailStandard: String?
    let publishedDate: String?
}

/** Intermediary Structure */
struct Articles: Codable {
    let copyright: String
    let numResults: Int
    let results: [Article]
}
