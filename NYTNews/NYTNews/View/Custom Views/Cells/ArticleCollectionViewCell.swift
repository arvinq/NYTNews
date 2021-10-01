//
//  ArticleCollectionViewCell.swift
//  NYTNews
//
//  Created by Arvin on 30/9/21.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    // reuse identifier
    static let reuseId = "ArticleCollectionViewCell"
    
    var separatorView = NYTSeparatorView()
    var textStackview = UIStackView()
    var articleTitleLabel = UILabel()
    var articleDescLabel = UILabel()
    var articleImageView = NYTImageView(frame: .zero)
    
    var articleCellViewModel: ArticleCellViewModel? {
        didSet { bindViewModel() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        addSubview(separatorView)
        
        // Container view for title and desc labels
        textStackview.axis = .vertical
        textStackview.alignment = .fill
        textStackview.distribution = .fillProportionally
        textStackview.spacing = Space.adjacentStack
        textStackview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textStackview)
        
        articleTitleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        articleTitleLabel.textColor = .label
        articleTitleLabel.numberOfLines = 2
        textStackview.addArrangedSubview(articleTitleLabel)

        articleDescLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        articleDescLabel.textColor = .label
        textStackview.addArrangedSubview(articleDescLabel)
        
        addSubview(articleImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // separator
            separatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            separatorView.widthAnchor.constraint(equalTo: widthAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // container view
            textStackview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Space.padding),
            textStackview.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor, constant: -Space.padding),
            textStackview.topAnchor.constraint(equalTo: topAnchor, constant: Space.padding),
            
            // imageview
            articleImageView.leadingAnchor.constraint(equalTo: textStackview.trailingAnchor, constant: -Space.padding),
            articleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Space.padding),
            articleImageView.topAnchor.constraint(equalTo: topAnchor, constant: Space.padding),
            articleImageView.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -Space.padding),
            articleImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            articleImageView.heightAnchor.constraint(equalTo: articleImageView.widthAnchor)
        ])
    }
    
    private func bindViewModel() {
        articleTitleLabel.text = articleCellViewModel?.title
        articleDescLabel.text = articleCellViewModel?.abstract
        articleImageView.downloadImage(from: articleCellViewModel?.thumbnailStandard)
    }
}
