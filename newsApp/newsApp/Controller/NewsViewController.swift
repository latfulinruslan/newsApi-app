//
//  NewsTableViewController.swift
//  newsApp
//
//  Created by Ruslan Latfulin on 8/27/19.
//  Copyright © 2019 Ruslan Latfulin. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController, UISearchResultsUpdating {
    
    var articles = [Article]()
    var searchArticles = [Article]()
    var isSearching = false
    
    var networkManager = AlamofireManager()
    
    lazy var currentDate = getString(from: Date())
    lazy var yesterdayDate = getYesterday(from: currentDate)
    lazy var params: [String: Any] = [
        "language" : "en",
        "from" : yesterdayDate,
        "to" : yesterdayDate
    ]
    var dayCounter = 0
    let newsAPI = "https://newsapi.org/v2/everything?apiKey=e0d394f9c82f4b14a62c2823b6709d97&q=apple"
    var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchBar()

        networkManager.getNews(from: newsAPI, params: params) { (articles) in
            self.articles = articles
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func getString(from date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    private func getYesterday(from date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let currDate = dateFormatter.date(from: date) else { return "" }
        return getString(from: currDate.dayBefore)
    }
    
    @IBAction func refreshAction(_ sender: UIRefreshControl) {
        networkManager.getNews(from: newsAPI, params: params) { (articles) in
            self.articles = articles
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        dayCounter = 0
        sender.endRefreshing()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == nil || searchController.searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            searchArticles.removeAll()
            tableView.reloadData()
        } else {
            isSearching = true
            
            searchArticles = articles.filter({ (article) -> Bool in
                return article.title!.lowercased().contains(searchController.searchBar.text!.lowercased())
            })
            tableView.reloadData()
        }
    }
    
    // MARK: - Search Bar
    private func configureSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchArticles.count
        }
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleTableViewCell
        
        var article = Article()
        
        if isSearching {
            article = searchArticles[indexPath.row]
        } else {
            article = articles[indexPath.row]
        }
         
        cell.titleLabel.text = article.title
        cell.descriptionTextView.limitedText = article.description
        
        if (article.urlToImage != nil) {
            DispatchQueue.main.async {
                self.networkManager.getImage(from: article.urlToImage!) { (data) in
                    cell.articleImageView.image = UIImage(data: data)
                }
            }
        } else {
            cell.articleImageView.image = #imageLiteral(resourceName: "photoPlaceholder")
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // MARK: - Animation
        let rotation = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotation
        cell.alpha = 0.5

        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
        
        // MARK: - Load previous news
        let lastItem = articles.count - 1
        guard indexPath.row == lastItem else { return }
        var currDate = currentDate
        if dayCounter != 0 {
            currDate = yesterdayDate
        }
        
        if dayCounter < 7  {

            print(yesterdayDate)
                
            params["from"] = yesterdayDate
            params["to"] = yesterdayDate
            print(params)
                
            networkManager.getNews(from: newsAPI, params: params) { (articles) in
                self.articles += articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            dayCounter += 1
            yesterdayDate = getYesterday(from: currDate)
        }
    }
}

