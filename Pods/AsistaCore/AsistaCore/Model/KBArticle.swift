//
//  KBArticle.swift
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

/// Used to store `KBArticle` data associated with a decoded response.
public struct KBArticle: Codable {
    public let id: Int
    public let topic: String
    public let articleCount: Int
    public let articles: [Article]
    
    enum CodingKeys: String, CodingKey {
        case id, topic
        case articleCount = "article_count"
        case articles = "kbArticles"
    }
    
    public init(id: Int, topic: String, articleCount: Int, articles: [Article]) {
        self.id = id
        self.topic = topic
        self.articleCount = articleCount
        self.articles = articles
    }
}

public struct Article: Codable {
    public let id: Int
    public let subject: String
}


extension KBArticle: Equatable {
    public static func == (lhs: KBArticle, rhs: KBArticle) -> Bool {
        return lhs.id == rhs.id
            && lhs.topic == rhs.topic
            && lhs.articleCount == rhs.articleCount
            && lhs.articles == rhs.articles
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let topic: String = try container.decode(String.self, forKey: .topic)
        let articleCount = try container.decode(Int.self, forKey: .articleCount)
        let articles = try container.decode([Article].self, forKey: .articles)
        
        self.init(id: id, topic: topic, articleCount: articleCount, articles: articles)
    }
}

extension Article: Equatable {
    public static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id
            && lhs.subject == rhs.subject
    }
}
