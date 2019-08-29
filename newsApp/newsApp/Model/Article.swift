//
//  Article.swift
//  newsApp
//
//  Created by Ruslan Latfulin on 8/27/19.
//  Copyright © 2019 Ruslan Latfulin. All rights reserved.
//

import RealmSwift

class Article: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var author: String?
    @objc dynamic var desc: String?
    @objc dynamic var publishedAt: String?
    @objc dynamic var urlToImage: String?
    @objc dynamic var url: String?
    @objc dynamic var content: String?
    @objc dynamic var image: Data?
    
    convenience init(author: String?, title: String, desc: String?, publishedAt: String?, urlToImage: String?, url: String?, content:String?, image: Data?) {
        self.init()
        self.author = author
        self.title = title
        self.desc = desc
        self.publishedAt = publishedAt
        self.urlToImage = urlToImage
        self.url = url
        self.content = content
        self.image = image
    }
    
    override class func primaryKey() -> String? {
        return "title"
    }
}
