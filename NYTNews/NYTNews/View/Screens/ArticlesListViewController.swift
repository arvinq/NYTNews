//
//  ArticlesListViewController.swift
//  NYTNews
//
//  Created by Arvin Quiliza on 9/29/21.
//

import UIKit

class ArticlesListViewController: UIViewController {

    // section to be used in our diffable datasource
    enum Section { case main }
    
    var collectionView: UICollectionView!
    var datasource: UICollectionViewDiffableDataSource<Section, ArticleCellViewModel>!
    var activityIndicator: UIActivityIndicatorView!
    var hasMoreArticles = true
    var page = 0;
    
    lazy var viewModelManager: ViewModelManager = {
        return ViewModelManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        setupView()
        setupConstraints()
        setupDatasource()
        setupViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Current News"
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: ArticleCollectionViewCell.reuseId)
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Space.padding),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModelManager.presentAlert = { [weak self] in
            guard let self = self else { return }
            let message = self.viewModelManager.alertMessage ?? ""
            
            DispatchQueue.main.async {
                self.presentAlert(withTitle: "News Article", andMessage: message, buttonTitle: "Ok")
            }
        }
        
        viewModelManager.reloadCollection = { [weak self] viewModels in
            guard let self = self else { return }
            //DispatchQueue.main.async { self.collectionView.reloadData() }
            
            // Create a snapshot from the passed view model list which subsequently updates our datasource.
            var snapShot = NSDiffableDataSourceSnapshot<Section, ArticleCellViewModel>()
            snapShot.appendSections([.main])
            snapShot.appendItems(viewModels)
            self.datasource.apply(snapShot, animatingDifferences: true)
        }
        
        viewModelManager.animateLoadView = { [weak self] in
            guard let self = self else { return }
            let isLoading = self.viewModelManager.isLoading
            
            DispatchQueue.main.async {
                if isLoading {
                    self.activityIndicator.startAnimating()
                    UIView.animate(withDuration: Animation.duration) {
                        self.collectionView.alpha = Alpha.weakFade
                    }
                } else {
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: Animation.duration) {
                        self.collectionView.alpha = Alpha.solid
                    }
                }
            }
        }
        
        viewModelManager.toggleHasMoreArticles = { [weak self] in
            guard let self = self else { return }
            self.hasMoreArticles.toggle()
        }
        
        viewModelManager.getArticles(on: page, hasMoreArticles: hasMoreArticles)
    }

}

extension ArticlesListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    /**
     * Create our diffable datasource to manage our model and create/provide a cell based on our viewModel.
     */
    private func setupDatasource() {
        datasource = UICollectionViewDiffableDataSource<Section, ArticleCellViewModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, articleCellViewModelIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCollectionViewCell.reuseId, for: indexPath) as! ArticleCollectionViewCell
            cell.articleCellViewModel = articleCellViewModelIdentifier
            
            return cell
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width * 0.85
        let cellHeight = collectionView.frame.height * 0.15
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // get our view model in the datasource pointed to by the selected indexpath
        guard let articleViewModel = datasource.itemIdentifier(for: indexPath) else { return }
        
        let articleInfoVC = ArticleInfoViewController()
        let navController = UINavigationController(rootViewController: articleInfoVC)
        articleInfoVC.articleViewModel = articleViewModel
        articleInfoVC.viewModelManager = viewModelManager
        
        present(navController, animated: true)
    }
    
    /**
     * Accessomg scrollView delegate from our collectionView to process pagination when going to the next page (scrolling to the bottom)
     */
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y // how far have you scrolled
        let contentHeight = scrollView.contentSize.height // height of all the contents inside the collection view
        let height = scrollView.frame.size.height // height of the view
        
        if offsetY > contentHeight - height {
            guard hasMoreArticles else { return }
            page += 1
            viewModelManager.getArticles(on: page, hasMoreArticles: hasMoreArticles)
        }
    }
}

