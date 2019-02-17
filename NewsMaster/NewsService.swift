//
//  NewsService.swift
//  NewsMaster
//
//  Created by Vincent Yu on 2/16/19.
//  Copyright © 2019 Vincent Yu. All rights reserved.
//

import Foundation

struct NewsSource: Codable {
    let id: String?
    let name: String
}

struct News: Codable {
    let source: NewsSource
    let author: String?
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String?
}

struct NewsResult: Codable {
    let status: String
    let totalResults: Int
    let articles: [News]
}

enum ErrorType {
    case NetworkFailed, JSONParseFailed
}

class NewsService {
    // MARK: Properties
    private let urlString = "https://newsapi.org/v2/everything?q="
    
    // MARK: Function
    public func search(for searchTerm: String, completion: @escaping ([News]?, Error?, ErrorType?) -> ()) {
        // Construct url request
        guard let url = URL(string: urlString + searchTerm) else {
            fatalError("Error: Unexpected URL")
        }
        var urlRequest = URLRequest(url: url)
        /*===------------------------ ADD YOUR API HERE ------------------------===*/
        urlRequest.addValue("4f03e85e42594a1aa1633ad351bdd14c", forHTTPHeaderField: "X-Api-Key")
        
        // Create tasks
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            // Error appears when network fails
            guard let data = data, let _ = response as? HTTPURLResponse, error == nil else {
                DispatchQueue.main.async { completion(nil, error, ErrorType.NetworkFailed) }
                return
            }
            //print(String(data: data, encoding: .utf8) ?? "Error: Unable to print data")
            
            do {
                let decoder = JSONDecoder()
                let newsResult = try decoder.decode(NewsResult.self, from: data)
                DispatchQueue.main.async { completion(newsResult.articles, nil, nil) }
            } catch(let error) {
                DispatchQueue.main.async { completion(nil, error, ErrorType.JSONParseFailed) }
            }
            //print("Status code: \(response.statusCode)")
            
        }
        task.resume()
    }
}
