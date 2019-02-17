//
//  MasterViewController.swift
//  NewsMaster
//
//  Created by Vincent Yu on 2/15/19.
//  Copyright © 2019 Vincent Yu. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchBarDelegate {
    // MARK: Properties
    private let newsService = NewsService()
    public var news: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create search bar in the navigation bar
        setNavigationBar()
        
        // Initialize interface with "Apple" news
        newsService.search(for: "Apple", completion: searchCompletion(_:_:_:))
    }
    
    func setNavigationBar() {
        let navSearchBar = UISearchBar()
        navSearchBar.placeholder = "Search"
        navSearchBar.delegate = self
        navigationItem.titleView = navSearchBar
        
        // let navSearchController = UISearchController(searchResultsController: nil)
        // navigationItem.searchController = navSearchController
        // navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: Delegations
    
    private func searchCompletion(_ news: [News]?, _ error: Error?, _ errorType: ErrorType?) {
        guard let news = news, error == nil else {
            
            // Alert when network fails
            if errorType == ErrorType.NetworkFailed {
                let alertController = UIAlertController(title: "Connection Failed", message: "Please check your network state", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    alertController.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            // Print error information
            print(error ?? "Error: Unknown")
            return
        }
        self.news = news
        
        // No search result
        if self.news.count == 0 {
            let alertController = UIAlertController(title: "No Result Found", message: "Try changing the keyword", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            
            /*
            let detailViewController = self.splitViewController!.viewControllers[1] as! DetailViewController
            if detailViewController.url == nil && news.count > 0 {
                let newsPiece = self.news[0]
                
                detailViewController.sourceLabel.text = newsPiece.source.name
                detailViewController.webView.alpha = 1
                detailViewController.FailedLabel.isHidden = true
                
                // Load web page
                let urlRequest = URLRequest(url: URL(string: newsPiece.url)!)
                detailViewController.webView.load(urlRequest)
            }
             */
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        newsService.search(for: searchBar.text ?? "", completion: searchCompletion(_:_:_:))
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsViewCell else {
            fatalError("Error: Unknown error")
        }
        
        let newsPiece = news[indexPath.row]
        cell.TitleLabel.text = newsPiece.title
        cell.AuthorLabel.text = newsPiece.author
        
        // Hide or display "RECENT" label
        let publishedDate = newsPiece.publishedAt.replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: "")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: publishedDate) else {
            fatalError("Error: Unresolved Date Format")
        }
        // Earlier than 1 month
        if Calendar.current.date(byAdding: .month, value: 1, to: date)! < Date() {
            cell.RecentLabel.isHidden = true
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? DetailViewController else { return }
        guard let src = sender as? NewsViewCell else { return }
        
        guard let index = tableView.indexPath(for: src)?.row else { return }
        let newsPiece = news[index]
        
        dest.sourceText = newsPiece.source.name
        dest.url = URL(string: newsPiece.url)
        dest.color = navigationController?.navigationBar.barTintColor
    }
}
