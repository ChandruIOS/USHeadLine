//
//  WebService.swift
//  USHeadlines
//
//  Created by siva chitran p on 11/08/22.
//

import Foundation

class WebService: NSObject {
    
    static let getNewsUrl = "https://newsapi.org/v2/everything?q=tesla&from=2022-07-12&sortBy=publishedAt&apiKey=22191269acc64ae094103fd492135882"
    static let getLikeUrl = "https://cn-news-info-api.herokuapp.com/likes/"
    static let getCommentUrl = "https://cn-news-info-api.herokuapp.com/comments/"
}
