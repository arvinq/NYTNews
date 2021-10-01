//
//  NYTSeparatorView.swift
//  NYTNews
//
//  Created by Arvin on 1/10/21.
//

import UIKit

class NYTSeparatorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor = .tertiaryLabel) {
        self.init(frame: CGRect.zero)
        backgroundColor = color
    }
    
    private func setup() {
        backgroundColor = .tertiaryLabel
        translatesAutoresizingMaskIntoConstraints = false
    }

}
