//
//  ViewController.swift
//  newsApp
//
//  Created by Ruslan Latfulin on 8/27/19.
//  Copyright © 2019 Ruslan Latfulin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AlamofireManager.getNews(from: "https://newsapi.org/v2/everything?q=apple&from=2019-08-26&to=2019-08-26&apiKey=e0d394f9c82f4b14a62c2823b6709d97")
    }


}
