//
//  NewsTableViewController.swift
//  newsApp
//
//  Created by Ruslan Latfulin on 8/27/19.
//  Copyright © 2019 Ruslan Latfulin. All rights reserved.
//

import UIKit
import RealmSwift

class NewsViewController: UITableViewController, UISearchResultsUpdating {
    
    var articles: Results<Article>!
    var searchArticles = [Article]()
    var isSearching = false
    var currentRowsInSection = Constants.rowInSection
    
    var networkManager = AlamofireManager()
    
    lazy var currentDate = Date().getString()
    lazy var yesterdayDate = getYesterday(from: currentDate)
    lazy var params: [String: Any] = [
        "language" : "en",
        "from" : currentDate,
        "to" : currentDate
    ]
    var dayCounter = 0
    let newsAPI = Constants.newsAPI
    var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        DispatchQueue.main.async {
            StorageManager.checkDB()
        }
        if networkManager.isConected() && (articles == nil) {
            DispatchQueue.global().async {
                self.networkManager.getNews(from: self.newsAPI, params: self.params) {
                    DispatchQueue.main.async {
                        self.articles = realm.objects(Article.self)
                        self.updateTable()
                    }
                }
            }
        } else {
            let alertContlroller = UIAlertController(title: "Error", message: "Check internet conection", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertContlroller.addAction(ok)
            present(alertContlroller, animated: true)
            articles = realm.objects(Article.self)
        }
    }
    
    private func getYesterday(from date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let currDate = dateFormatter.date(from: date) else { return "" }
        return currDate.dayBefore.getString()
    }
    
    // MARK: - Pull-To-Refresh
    @IBAction func refreshAction(_ sender: UIRefreshControl) {
        guard networkManager.isConected() else { return }
        params = [
            "language" : "en",
            "from" : currentDate,
            "to" : currentDate
        ]
        
        networkManager.getNews(from: newsAPI, params: params) {
            self.articles = realm.objects(Article.self)
        }
        dayCounter = 0
        currentRowsInSection = Constants.rowInSection
        yesterdayDate = getYesterday(from: currentDate)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            sender.endRefreshing()
            self.updateTable()
        }
    }
    // MARK: - Updating Table
    private func updateTable() {
        networkManager.loadImages()
        tableView.reloadData()
    }
    
    // MARK: - Search Bar
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == nil || searchController.searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            searchArticles.removeAll()
            tableView.reloadData()
        } else {
            isSearching = true
            
            searchArticles = articles.filter({ (article) -> Bool in
                return article.title.lowercased().contains(searchController.searchBar.text!.lowercased())
            })
            tableView.reloadData()
        }
    }
    
    private func configureSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchArticles.count
        }
        
        guard articles != nil else { return 0 }
        return currentRowsInSection
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleTableViewCell
        
        let article = isSearching ? searchArticles[indexPath.row] : articles[indexPath.row]

         
        cell.titleLabel.text = article.title
        cell.descriptionTextView.limitedText = article.desc
        
        if let imageData = article.image{
            cell.articleImageView.image = UIImage(data: imageData)
        } else {
            cell.articleImageView.image = #imageLiteral(resourceName: "photoPlaceholder")
        }
        return cell
    }
    
    // MARK: - Load previous news
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard networkManager.isConected() else { return }
        guard indexPath.row == currentRowsInSection - 1 else { return }
        
        let currDate = yesterdayDate
                
        guard currentRowsInSection < Constants.maxRows else { return }
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            params["from"] = currDate
            params["to"] = currDate
                    
            networkManager.getNews(from: newsAPI, params: params) {
                DispatchQueue.main.async {
                    spinner.stopAnimating()
                    self.dayCounter += 1
                    self.currentRowsInSection += Constants.rowInSection
                    self.updateTable()
                }
            }
            yesterdayDate = getYesterday(from: currDate)
        }
    }
}


