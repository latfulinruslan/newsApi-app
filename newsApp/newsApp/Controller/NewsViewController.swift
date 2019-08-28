//
//  NewsTableViewController.swift
//  newsApp
//
//  Created by Ruslan Latfulin on 8/27/19.
//  Copyright © 2019 Ruslan Latfulin. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController, UISearchResultsUpdating, UITextViewDelegate {
    
    var resultSearchController = UISearchController()
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
                tableView.estimatedRowHeight = 130
                tableView.rowHeight = UITableView.automaticDimension
        
        return true
    }
    
    var articles = [Article]()
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBar()
        
        
//        self.tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.estimatedRowHeight = 130
        
        AlamofireManager.getNews(from: "https://newsapi.org/v2/everything?q=bitcoin&apiKey=e0d394f9c82f4b14a62c2823b6709d97") { (articles) in
            self.articles = articles
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        // "https://newsapi.org/v2/everything?q=bitcoin&apiKey=e0d394f9c82f4b14a62c2823b6709d97")
    }
    
    private func configureSearchBar() {
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            tableView.tableHeaderView = controller.searchBar

            return controller
        })()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleTableViewCell
        
        let article = articles[indexPath.row]

        cell.titleLabel.text = article.title
        cell.descriptionTextView.limitedText = article.description
        
        if (article.urlToImage != nil) {
            DispatchQueue.main.async {
                AlamofireManager.getImage(from: article.urlToImage!) { (data) in
                    cell.articleImageView.image = UIImage(data: data)
                }
            }
        } else {
            cell.articleImageView.image = #imageLiteral(resourceName: "photoPlaceholder")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotation = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotation
        cell.alpha = 0.5
        
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

