//
//  NewsViewModel.swift
//  USHeadlines
//
//  Created by siva chitran p on 12/08/22.
//

import Foundation
import UIKit

class NewsViewModel: NSObject {
    
    weak var dataSource: GenericDataSource<Articles>?
    let likegroup = DispatchGroup()
    let commentgroup = DispatchGroup()
    var viewController = UIViewController()
    var reloadData: (() -> ())?
    init(dataSource: GenericDataSource<Articles>, vcs: UIViewController) {
        self.dataSource = dataSource
        self.viewController = vcs
    }
    // MARK: - All NEWS GET Api Call
    func getNewsApiCall(completion: @escaping(_ status: String,
                                              _ msg: String) -> ()) {
        viewController.showloader(true)
        URLHandler.shared.getResponseUsingGetMethod(urlString: WebService.getNewsUrl) { [weak self] responseData, status in
            if(status) {
                do {
                    let response = try JSONDecoder().decode(NewsModel.self, from: responseData)
                    dump(response)
                    if let statuscode = response.status {
                        if statuscode == "ok" {
                            guard let article = response.articles else{return}
                            self?.dataSource?.data.value = article
                            article.enumerated().forEach { index,element in
                                self?.LikeandCommentParam(likeUrl: Constant.checkNull(element.url), index: index)
                            }
                            self?.commentgroup.notify(queue: .main) {
                                self?.reloadData?()
                            }
                            self?.likegroup.notify(queue: .main) {
                                self?.reloadData?()
                            }
                            completion("1","")
                        }else{
                            completion("0","No Data Found.")
                        }
                    }
                }catch{
                    completion("0","")
                }
            }else{
                completion("0","Network Failed.")
            }
            self?.viewController.showloader(false)
        }
    }
    // MARK: - Like and Comment Paremeter Getting Function
    func LikeandCommentParam(likeUrl: String,index: Int) {
        var likeURL = Constant.checkNull(likeUrl)
        for str in likeURL{
            if str == "w"{
                break
            }
            likeURL.remove(at: likeURL.startIndex)
        }
        let  url = likeURL.replacingOccurrences(of: "/", with: "-")
        self.getLikeApiCall(param: url, index: index)
        self.getCommentsApiCall(param: url, index: index)
    }
    // MARK: - Like Count Get ApiCall
    func getLikeApiCall(param: String,index: Int) {
        likegroup.enter()
        URLHandler.shared.getResponseUsingGetMethod(urlString: WebService.getLikeUrl + param) { [weak self] responseData, status in
            if(status) {
                do {
                    let response = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as! NSDictionary
                    if let like = response["likes"] as? Int {
                        self?.dataSource?.data.value[index].likes = like
                    }
                }catch (let error){
                    print(error.localizedDescription)
                }
            }
            self?.likegroup.leave()
        }
    }
    // MARK: - Comment Count Get ApiCall
    func getCommentsApiCall(param: String,index: Int) {
        commentgroup.enter()
        URLHandler.shared.getResponseUsingGetMethod(urlString: WebService.getCommentUrl + param) { [weak self] responseData, status in
            if(status) {
                do {
                    let response = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as! NSDictionary
                    if let comment = response["comments"] as? Int {
                        self?.dataSource?.data.value[index].comments = comment
                    }
                }catch (let error){
                    print(error.localizedDescription)
                }
            }
            self?.commentgroup.leave()
        }
    }
}
