//
//  NetworkTests.swift
//  NYTNewsTests
//
//  Created by Arvin on 1/10/21.
//

import Foundation
import XCTest
@testable import NYTNews

class NetworkTests: XCTestCase {
    var sut: NetworkManager?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkManager()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    // check if there's data returned based on network state
    func test_get_news() {
        let sut = self.sut!
        
        let expect = XCTestExpectation(description: "callback")
        
        sut.getNews(onPage: 0) { result in
            expect.fulfill()
            
            switch result {
                case .success(let articles):
                    XCTAssertEqual(articles.count, 20) // limit in articles
                    
                    //lets just test if there's a slugName (id) for each article fetched
                    let _ = articles.map { XCTAssertNotNil($0.slugName) }
                    
                case .failure(let error) :
                    XCTAssertNotNil(error)
            }
        }
        
        wait(for: [expect], timeout: 3.1)
    }
}
