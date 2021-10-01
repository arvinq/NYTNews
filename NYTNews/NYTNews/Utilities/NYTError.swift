//
//  NYTError.swift
//  NYTNews
//
//  Created by Arvin on 30/9/21.
//

import Foundation

enum NYTError: String, Error {
    case invalidUrl        = "Invalid Request. Please contact the administrator."
    case invalidData       = "The data received from the server is invalid. Please try again."
    case invalidResponse   = "Invalid response from the server. Please try again."
    case unableToComplete  = "Unable to complete your request. Please check your network connection."
    case unableToDecode   = "Unable to decode the data. Please check if you're decoding your data correctly."
}
