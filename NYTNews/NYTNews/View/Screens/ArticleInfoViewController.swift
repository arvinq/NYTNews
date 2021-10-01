//
//  ArticleInfoViewController.swift
//  NYTNews
//
//  Created by Arvin on 1/10/21.
//

import UIKit

class ArticleInfoViewController: UIViewController {
    // viewModel objects
    var viewModelManager: ViewModelManager?
    var articleViewModel: ArticleCellViewModel?
    
    // properties
    var articleImageView = NYTImageView(frame: .zero)
    var articleTitleLabel = UILabel()
    var articleDescLabel = UILabel()
    var articleByLine = UILabel()
    var articlePublishedDateLabel = UILabel()
    var articleUrlButton = UIButton()
    var separatorView = NYTSeparatorView()
    var articleUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupView()
        setupConstraints()
        setupViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
        
        view.addSubview(articleImageView)
        
        articleTitleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        articleTitleLabel.textColor = .label
        articleTitleLabel.numberOfLines = 0
        articleTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(articleTitleLabel)
        
        articleByLine.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        articleByLine.textColor = .label
        articleByLine.numberOfLines = 0
        articleByLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(articleByLine)
        
        articlePublishedDateLabel.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        articlePublishedDateLabel.textColor = .label
        articlePublishedDateLabel.numberOfLines = 0
        articlePublishedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(articlePublishedDateLabel)
        
        articleDescLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        articleDescLabel.textColor = .label
        articleDescLabel.numberOfLines = 0
        articleDescLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(articleDescLabel)
        
        articleUrlButton.setTitle("read full article", for: .normal)
        articleUrlButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        articleUrlButton.addTarget(self, action: #selector(articleUrlButtonTapped), for: .touchUpInside)
        articleUrlButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(articleUrlButton)
        
        view.addSubview(separatorView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            articleImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            articleImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            
            articleTitleLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: Space.adjacent),
            articleTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.padding),
            articleTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.padding),
            
            articleByLine.topAnchor.constraint(equalTo: articleTitleLabel.bottomAnchor, constant: Space.adjacent),
            articleByLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.padding),
            
            articlePublishedDateLabel.topAnchor.constraint(equalTo: articleByLine.bottomAnchor, constant: Space.padding),
            articlePublishedDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.padding),
            
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.padding),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.padding),
            separatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            separatorView.topAnchor.constraint(equalTo: articlePublishedDateLabel.bottomAnchor, constant: Space.adjacent),
            
            articleDescLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Space.adjacent),
            articleDescLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.padding),
            articleDescLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.padding),
            
            articleUrlButton.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),
            articleUrlButton.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor),
            articleUrlButton.heightAnchor.constraint(equalToConstant: Size.buttonHeight),
            articleUrlButton.topAnchor.constraint(equalTo: articleDescLabel.bottomAnchor, constant: Space.adjacent)
        ])
    }
    
    private func setupViewModel() {
        viewModelManager?.bindArticleInformation = { [weak self] articleInfoViewModel in
            // bind values
            guard let self = self else { return }
            
            self.articleImageView.downloadImage(from: articleInfoViewModel?.thumbnailStandard)
            self.articleTitleLabel.text = articleInfoViewModel?.title
            self.articleDescLabel.text = articleInfoViewModel?.abstract
            self.articleByLine.text = articleInfoViewModel?.byline
            self.articlePublishedDateLabel.text = articleInfoViewModel?.publishedDate.convertDateFormat()
            self.articleUrl = URL(string: articleInfoViewModel?.url ?? Network.mainNewsUrl)
        }
        
        guard let articleViewModel = articleViewModel else { return }
        viewModelManager?.getArticleInfo(for: articleViewModel)
    }
    
    /// Dismiss CurrentLocation view controller
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func articleUrlButtonTapped() {
        guard let articleUrl = articleUrl else { return }
        presentSafariViewController(with: articleUrl)
    }
}
