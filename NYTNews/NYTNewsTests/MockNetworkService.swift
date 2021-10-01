//
//  MockApiService.swift
//  NYTNewsTests
//
//  Created by Arvin on 1/10/21.
//

import Foundation
@testable import NYTNews
import UIKit

class MockNetworkService: NetworkManagerProtocol {
    
    var isGetArticleCalled = false
    
    var articles: [Article] = [Article]()
    var completion: ((Result<[Article], NYTError>) -> ())!
    
    func getNews(onPage page: Int, completion: @escaping (Result<[Article], NYTError>) -> Void) {
        isGetArticleCalled = true
        self.completion = completion
    }
    
    func getSuccess() {
        self.completion(.success(articles))
    }
    
    func getFail(error: NYTError) {
        self.completion(.failure(error))
    }
}
