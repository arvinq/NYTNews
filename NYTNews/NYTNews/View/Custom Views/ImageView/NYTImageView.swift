//
//  NYTImageView.swift
//  NYTNews
//
//  Created by Arvin on 1/10/21.
//

import UIKit

class NYTImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // other setup for imageView
        layer.cornerRadius = Space.cornerRadius
        clipsToBounds = true
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from url: String?) {
        // if there's no url passed, we simply return
        guard let url = url else { return }
        
        let networkManager = NetworkManager()
        networkManager.downloadImage(from: url) { [weak self] image in
            guard let self = self, let image = image else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }
}
