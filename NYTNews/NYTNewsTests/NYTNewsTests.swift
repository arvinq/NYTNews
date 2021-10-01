//
//  NYTNewsTests.swift
//  NYTNewsTests
//
//  Created by Arvin Quiliza on 9/29/21.
//

import XCTest
@testable import NYTNews

class NYTNewsTests: XCTestCase {

    var sut: ViewModelManager!
    var mockNetworkService: MockNetworkService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNetworkService = MockNetworkService()
        sut = ViewModelManager(networkManager: mockNetworkService)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockNetworkService = nil
        try super.tearDownWithError()
    }

    func test_get_news() {
        // test if API is called when getArticles is called
        sut.getArticles(on: 0, hasMoreArticles: true)
        XCTAssert(mockNetworkService.isGetArticleCalled)
    }
    
    func test_get_news_fail() {
        // test if correct alert is shown when an error is returned
        let error = NYTError.invalidResponse
        sut.getArticles(on: 0, hasMoreArticles: true)
        mockNetworkService.getFail(error: .invalidResponse)
        
        XCTAssertEqual(sut.alertMessage, error.rawValue)
    }
    
    func test_loading_when_fetching() {
        
        //Given
        var loadingStatus = false
        let expect = XCTestExpectation(description: "Loading status updated")
        
        sut.animateLoadView = { [weak sut] in
            loadingStatus = sut!.isLoading
            expect.fulfill()
        }
        
        //when fetching
        sut.getArticles(on: 0, hasMoreArticles: true)
        
        // Assert
        XCTAssertTrue( loadingStatus )
        
        // When finished fetching
        mockNetworkService!.getSuccess()
        XCTAssertFalse( loadingStatus )
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func test_cell_view_model() {
        let article = Article(slugName: "01wordplay-chen-horne", title: "Now!", abstract: "Friday puzzle.",
                              url: "https://www.nytimes.com/2021/09/30/crosswords/daily-puzzle-2021-10-01.html", byline: "by author",
                              thumbnailStandard: "https://static01.nyt.com/images/2021/10/01/crosswords/01wordplay-chen-horne/merlin_175558062_10cde7e8-c3a3-4dde-851b-f43636ad0d80-thumbStandard.jpg", publishedDate: "2021-09-30")
        
        let articleCellViewModel = ArticleCellViewModel(article: article)
        let articleInfoViewModel = ArticleInfoViewModel(article: article)
        
        // Assert the correctness of cell display information
        XCTAssertEqual(article.slugName, articleCellViewModel.slugName)
        XCTAssertEqual(article.title, articleCellViewModel.title)
        XCTAssertEqual(article.abstract, articleCellViewModel.abstract)
        
        XCTAssertEqual(article.byline, articleInfoViewModel.byline)
        XCTAssertEqual(article.publishedDate, articleInfoViewModel.publishedDate)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
