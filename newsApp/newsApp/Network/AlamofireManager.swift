//
//  AlamofireManager.swift
//  newsApp
//
//  Created by Ruslan Latfulin on 8/27/19.
//  Copyright © 2019 Ruslan Latfulin. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireManager {
    
    static func getNews(from url: String, params: Parameters?, completion: @escaping (_ articles: [Article]) -> ()) {
        guard let url = URL(string: url) else { return }
        
        AF.request(url, parameters: params).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                guard let rootDictionary = value as? Dictionary<String, Any> else { return }
                guard let arrayOfArticles = rootDictionary["articles"] as? [Dictionary<String, Any>] else { return }
                
                var articles = [Article]()
                
                for item in arrayOfArticles {
                    let article = Article(author: item["author"] as? String,
                                          title: item["title"] as? String,
                                          description: item["description"] as? String,
                                          publishedAt: item["publishedAt"] as? String,
                                          urlToImage: item["urlToImage"] as? String,
                                          url: item["url"] as? String,
                                          content: item["content"] as? String)
                    articles.append(article)
                }
                
                completion(articles)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func  getImage(from url: String, completion: @escaping (_ data: Data) -> ()) {
        guard let url = URL(string: url)  else { return }
        AF.request(url, method: .get).validate().responseData { (data) in
            switch data.result {
            case.success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
