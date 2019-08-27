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
    
    static func getNews(from url: String) {
        guard let url = URL(string: url) else { return }
        AF.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        
        }
    }
}
