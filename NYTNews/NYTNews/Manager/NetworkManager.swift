//
//  NetworkManager.swift
//  NYTNews
//
//  Created by Arvin on 1/10/21.
//

import UIKit

protocol NetworkManagerProtocol {
    func getNews(onPage page:Int, completion: @escaping (Result<[Article], NYTError>) -> Void)
}
class NetworkManager: NetworkManagerProtocol {
    
    let cache = NSCache<NSString, UIImage>()
    
    /**
     * Get news on specific page. This returns a Result set type containing the news articles or an error if encountered
     * In here we also compute for the offset which will be the start of the next page to fill our list
     *
     *  - Parameters:
     *     - page: next page to query
     *     - result: Result type that can return an array of articles or error
     */
    func getNews(onPage page:Int, completion: @escaping (Result<[Article], NYTError>) -> Void) {
        let limit = 20
        let offset = (page * limit)
        
        var queryItems = Network.queryItems
        queryItems["api-key"] = Network.apiKey
        queryItems["limit"] = "\(limit)"
        queryItems["offset"] = "\(offset)"
        
        
        guard let baseUrl = URL(string: Network.baseUrl),
              let endpoint = baseUrl.withQuery(items: queryItems) else {
                  completion(.failure(.invalidUrl))
                  return
              }
        
        let task = URLSession.shared.dataTask(with: endpoint) { data, response, error in
            // if error is present
            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }
            
            //if response is not OK
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            // if data is nil
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                // use our intermediary structure to decode the list of articles
                let jsonArticles = try decoder.decode(Articles.self, from: data)
                let articles = jsonArticles.results
                
                completion(.success(articles))
            } catch {
                // if there's an issue in decoding
                completion(.failure(.unableToDecode))
            }
        }
        
        task.resume()
    }
    
    /**
     * Get image using url string from articles. This returns an optional image. We've also incorporated image caching, where we check if the image is inside
     * the cache using the url as the key and return that image if it is in cache, else we cache the image if its not found in the cache.
     *
     * - Parameters:
     *      -   urlString: the url to get the image resource
     */
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        // return the image if its already in our cache
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data, let image = UIImage(data: data) else {
                      completion(nil)
                      return
                  }
            
            // cache our image
            self?.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        
        task.resume()
    }
}
