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
    
    func getNews(from url: String, params: Parameters?, completion: @escaping () -> ()) {
        guard let url = URL(string: url) else { return }
        
        AF.request(url, parameters: params).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                guard let rootDictionary = value as? Dictionary<String, Any> else { return }
                guard let arrayOfArticles = rootDictionary["articles"] as? [Dictionary<String, Any>] else { return }
                
                for item in arrayOfArticles {
                    let article = Article(author: item["author"] as? String,
                                          title: item["title"] as! String,
                                          desc: item["description"] as? String,
                                          publishedAt: item["publishedAt"] as? String,
                                          urlToImage: item["urlToImage"] as? String,
                                          url: item["url"] as? String,
                                          content: item["content"] as? String,
                                        image: nil)
                    StorageManager.saveObject(article)
                }
                self.loadImages()
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func  loadImages() {
        let articles = realm.objects(Article.self).filter("image == nil")
        for article in articles where article.urlToImage != nil {
            DispatchQueue.main.async {
                AF.request(article.urlToImage!).validate().response { (response) in
                    switch response.result {
                    case .success(let value):
                        try! realm.write {
                            article.image = value
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
        }
    }
    
    func isConected() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
