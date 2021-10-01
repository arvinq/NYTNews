//
//  URL+Ext.swift
//  NYTNews
//
//  Created by Arvin on 1/10/21.
//

import Foundation

extension URL {
    func withQuery(items: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = items.compactMap { return URLQueryItem(name: $0.key, value: $0.value) }
        return components?.url
    }
}
