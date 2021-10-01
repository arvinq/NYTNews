//
//  ViewModelManager.swift
//  NYTNews
//
//  Created by Arvin on 30/9/21.
//

import Foundation

class ViewModelManager {
    
    let networkManager: NetworkManagerProtocol
    
    private var articles: [Article] = []
    
    // properties that triggers binding and updates our view
    
    var articleInfoViewModel: ArticleInfoViewModel? {
        didSet { self.bindArticleInformation?(articleInfoViewModel) }
    }
    
    var articleCellViewModels: [ArticleCellViewModel] = [] {
        didSet { self.reloadCollection?(articleCellViewModels) }
    }
    
    var alertMessage: String? {
        didSet { self.presentAlert?() }
    }
    
    var isLoading: Bool = false {
        didSet { self.animateLoadView?() }
    }
    
    var hasMoreArticles: Bool = true {
        didSet { self.toggleHasMoreArticles?() }
    }
    
    // bindings
    var presentAlert: (()->())?
    var reloadCollection: (([ArticleCellViewModel])->())?
    var animateLoadView: (()->())?
    var toggleHasMoreArticles: (()->())?
    var bindArticleInformation: ((ArticleInfoViewModel?)->())?
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getArticles(on page: Int, hasMoreArticles: Bool) {
        self.isLoading = true
        self.networkManager.getNews(onPage: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let articles):
                // if articles retrieved is less than the allowable article displayed, then we invert our flag
                // to prevent another query when dragging
                
                if articles.count < 20 { self.hasMoreArticles = false}
                var tempArticleCellViewModels = [ArticleCellViewModel]()
                tempArticleCellViewModels.append(contentsOf: articles.map{ ArticleCellViewModel(article: $0) })
                self.articleCellViewModels = tempArticleCellViewModels // will trigger the reload
                self.articles = articles
                
            case .failure(let error):
                self.alertMessage = error.rawValue
            
            }
        }
    }
    
    func getArticleInfo(for articleViewModel: ArticleCellViewModel) {
        guard let article = self.articles.filter({ $0.slugName == articleViewModel.slugName }).first else { return }
        
        self.articleInfoViewModel = ArticleInfoViewModel(article: article)
    }
}
