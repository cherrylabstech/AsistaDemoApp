//
//  KBArticleTVC.swift
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

@available(iOS 9.0, *)
class KBArticlesTVC: UITableViewController {
    
    var topicId: Int?
    var articleList = [Article]()
    lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topicId = topicId {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ArticleCell")
            loadArticle(topicId: topicId)
        }
    }
    
    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
        closeViewController()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath)
        cell.textLabel?.text = articleList[indexPath.row].subject
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = KBContentsVC()
        if articleList.indices.contains(indexPath.row) {
            vc.navigationItem.backBarButtonItem?.title = "Back"
            vc.articleId = articleList[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    /// Fetching KB Article list from Asista Core SDK
    ///
    /// - Parameter topicId: `id` of the topic which articles are listed.
    private func loadArticle(topicId: Int) {
        try! AsistaCore.getInstance().getKbService().fetchKbArticles(with: topicId) { (result) in
            switch result {
            case .success(let article):
                self.title = article.topic
                self.articleList = article.articles
                DispatchQueue.main.async { self.tableView.reloadData() }
            case .failed(let e):
                UIAlertController.presentAlert(title: "Alert", message: e.localizedDescription)
            }
        }
    }
    
}
