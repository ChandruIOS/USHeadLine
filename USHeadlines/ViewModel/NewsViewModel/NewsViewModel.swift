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
                            self?.reduceImages()
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
        self.likeCommentCall(url: url, index: index)
    }
    // MARK: - Like Count Get ApiCall
    func getLikeApiCall(param: String,index: Int) {
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
        }
    }
    // MARK: - Comment Count Get ApiCall
    func getCommentsApiCall(param: String,index: Int) {
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
        }
    }
    // MARK: - Like and comment Api Background Call Function
    
    func likeCommentCall(url: String, index: Int) {
        DispatchQueue.global(qos: .background).async {
            self.getLikeApiCall(param: url, index: index)
            self.getCommentsApiCall(param: url, index: index)
        }
    }
    // MARK: - DownSampling Image Size Reducing Function
    func reduceImages(){
        DispatchQueue.global(qos: .background).async {
            guard let element = self.dataSource else {
            return
            }
            element.data.value.enumerated().forEach { (index,element) in
                guard let url = URL(string: Constant.checkNull(element.urlToImage))else{return}
                guard let image = self.downsample(imageAt: url)else{return}
                self.dataSource?.data.value[index].newsImages = image
            }
        }
    }
    
    func downsample(imageAt imageURL: URL,
                    scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)else {
            return nil
        }
        // Calculate the desired dimension
        let maxDimensionInPixels = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * scale
        // Perform downsampling
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        // Return the downsampled image as UIImage
        return UIImage(cgImage: downsampledImage)
    }
}

