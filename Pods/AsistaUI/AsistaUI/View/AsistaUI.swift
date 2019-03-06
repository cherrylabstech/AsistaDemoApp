//
//  AsistaUI.swift
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


import Foundation
import AsistaCore

@available(iOS 11.0, *)
public class AsistaUI {
    
    /// Returns the Knowledge base view.
    ///
    /// - Parameter viewController: viewController instance provided from the host application to present the view
    public class func showKnowledgeBase(on viewController: UIViewController) {
        let navigationVC = UINavigationController()
        navigationVC.addChild(KBTopicsTVC())
        viewController.present(navigationVC, animated: true, completion: nil)
    }
    
//    /// Returns the Knowledge base Article view.
//    ///
//    /// - Parameter viewController: viewController instance provided from the host application to present the view
//    public class func showKnowledgeBaseArticle(topic: KBTopic, on viewController: UIViewController) {
//        let navigationVC = UINavigationController()
//        let article = KBArticlesTVC()
//        article.topic = topic
//        navigationVC.addChild(article)
//        viewController.present(navigationVC, animated: true, completion: nil)
//    }
    
    
    /// Returns the Ticket list view.
    ///
    /// - Parameter viewController: viewController instance provided from the host application to present the view
    public class func showTicketList(on viewController: UIViewController) {
        let navigationVC = UINavigationController()
        navigationVC.addChild(MyTicketsVC())
        viewController.present(navigationVC, animated: true, completion: nil)
    }
    
    /// Returns the Asset list view.
    ///
    /// - Parameter viewController: viewController instance provided from the host application to present the view
    public class func showAssets(on viewController: UIViewController) {
        let navigationVC = UINavigationController()
        navigationVC.addChild(AssetsTVC())
        viewController.present(navigationVC, animated: true, completion: nil)
    }
    
    /// Returns the ticket creation view.
    ///
    /// - Parameter viewController: viewController instance provided from the host application to present the view
    public class func showCreateTicket(on viewController: UIViewController) {
        let navigationVC = UINavigationController()
        navigationVC.addChild(CreateTicketVC())
        viewController.present(navigationVC, animated: true, completion: nil)
    }
}