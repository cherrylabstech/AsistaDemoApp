//
//  KBTopicsTVC.swift
//
//  Copyright (c) 2019 Cherrylabs Technologies (http://cherrylabs.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


import AsistaCore
import Foundation

@available(iOS 11.0, *)
class KBTopicsTVC: UITableViewController {
    
    var isSearching = false
    var topicList = [KBTopic]()
    var articleList = [KBArticleSearch]()
    
    lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Knowledge Base"
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TopicCell")
        loadTopics()
    }
    
    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        closeViewController()
    }
    
    
    /// Search controller to integrate in ta tableview.
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search articles.."
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        return searchController
    } ()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? articleList.count : topicList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath)
        if isSearching {
            cell.textLabel?.text = articleList[indexPath.row].subject
        } else {
            cell.textLabel?.text = topicList[indexPath.row].topic
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        footer.textLabel?.textAlignment = .center
        footer.textLabel?.font = .systemFont(ofSize: 11)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Powered by asista"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            let vc = KBContentsVC()
            if articleList.indices.contains(indexPath.row) {
                vc.articleId = articleList[indexPath.row].articleId
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        else {
            let vc = KBArticlesTVC()
            if topicList.indices.contains(indexPath.row) {
                vc.topicId = topicList[indexPath.row].id
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    /// Fetching Topic list from asista Api
    private func loadTopics() {
        try! AsistaCore.getInstance().getKbService().fetchKbTopics { (result) in
            switch result {
            case .success(let topics):
                self.topicList = topics
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failed(let e):
                UIAlertController.presentAlert(title: "Alert", message: e.localizedDescription)
            }
        }
    }
}


// MARK: - UISearchBarDelegate, UISearchResultsUpdating

@available(iOS 11.0, *)
extension KBTopicsTVC: UISearchBarDelegate, UISearchResultsUpdating {
    
    private func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            self.isSearching = true
            searchArticle(with: text)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count >= 3  {
            self.isSearching = true
            searchArticle(with: text)
        }
        else {
            self.isSearching = false
        }
        self.tableView.reloadData()
    }
    
    
    /// Fetching articles from asista Api using search text
    ///
    /// - Parameter searchText: Query text that user search for.
    private func searchArticle(with searchText: String) {
        articleList.removeAll()
        try! AsistaCore.getInstance().getKbService().searchKBArticles(query: searchText) { (result) in
            switch result {
            case .success(let articles):
                self.articleList = articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failed(let e):
                UIAlertController.presentAlert(title: "Alert", message: e.localizedDescription)
            }
        }
    }
}

