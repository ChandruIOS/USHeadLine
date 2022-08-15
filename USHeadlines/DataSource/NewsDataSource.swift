//
//  NewsDataSource.swift
//  USHeadlines
//
//  Created by siva chitran p on 12/08/22.
//

import Foundation
import UIKit

protocol NewsProtocol: AnyObject {
    func didTapNews(Article: Articles)
}

class NewsDataSource: GenericDataSource<Articles>,
                      UITableViewDelegate,
                      UITableViewDataSource {
    var viewcontroller = UIViewController()
    weak var delegate: NewsProtocol?
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell",
                                                 for: indexPath) as! NewsTableViewCell
        let dict = data.value[indexPath.row]
        guard let fileUrl = URL(string: Constant.checkNull(dict.urlToImage))else {return UITableViewCell()}
        cell.newsImgView.layer.cornerRadius = 10.0
        cell.newsImgView.image = dict.newsImages
        cell.newsTitleLbl.text = Constant.checkNull(dict.title)
        cell.authorNameLbl.text = "-\(Constant.checkNull(dict.author))"
        cell.newsDescriptionLbl.text = Constant.checkNull(dict.description)
        cell.likeBtn.setTitle(Constant.checkNull(dict.likes) + " Likes", for: .normal)
        cell.commentBtn.setTitle(Constant.checkNull(dict.comments) + " Comments", for: .normal)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didTapNews(Article: data.value[indexPath.row])
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
