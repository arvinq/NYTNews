//
//  Constant.swift
//  NYTNews
//
//  Created by Arvin on 30/9/21.
//

import UIKit

/// Constant values that represents Spaces used in the app
enum Space {
    static let padding: CGFloat = 8.0
    static let adjacent: CGFloat = 16.0
    static let adjacentStack: CGFloat = 8.0
    static let cornerRadius: CGFloat = 5.0
}

/// Constant values that represents Sizes used in the app
enum Size {
    static let buttonHeight: CGFloat = 40.0
    static let separatorHeight: CGFloat = 1.0
}

/// All the constant values that will be used for animations will be contained here
enum Animation {
    static let duration: CGFloat = 0.35
}

/// Easy access values to control alpha properties for the UIElements in the app
enum Alpha {
    static let none: CGFloat = 0.0
    static let weakFade: CGFloat = 0.3
    static let mid: CGFloat = 0.5
    static let strongFade: CGFloat = 0.8
    static let solid: CGFloat = 1.0
}

/// Easy access values used for our network manager
enum Network {
    static let baseUrl = "https://api.nytimes.com/svc/news/v3/content/all/all.json"
    static let apiKey = "8oNGJtEPvsraIIeb5mJk5vBGDqVLAQcm"
    static var queryItems: [String: String] = [:]
    static let mainNewsUrl = "www.nytimes.com"
}
