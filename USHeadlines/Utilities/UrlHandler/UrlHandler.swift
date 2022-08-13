//
//  UrlHandler.swift
//  USHeadlines
//
//  Created by siva chitran p on 11/08/22.
//

import Foundation
import Alamofire

class URLHandler: NSObject {
    static let  shared  = URLHandler()
    // MARK: - GET METHOD
    func getResponseUsingGetMethod(urlString: String,completionHandler:@escaping(_ responseData: Data,
                                                                            _ status: Bool ) -> Void) {
        print("urlString--->\(urlString)")
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        URLCache.shared.removeCachedResponse(for: urlRequest)
        let headers: HTTPHeaders = [:]
        AF.request(urlString,
                   method: .get,
                   encoding: URLEncoding.httpBody,
                   headers: headers).response { response in
            print("Response ===>", response)
            var returndata = Data()
            switch response.result {
            case .success:
                print(response)
                if let data = response.data {
                    returndata = data
                    completionHandler(returndata, true)
                }
            case .failure:
                completionHandler(returndata, false)
            }
        }
    }
    // MARK: - POST METHOD
    func getResponseUsingPostMethod(urlString: String,
                                                 params: [String: Any],
                                                 completionHandler: @escaping(_ responseData: Data,
                                                                              _ status: Bool) -> Void) {
        print("urlString--->\(urlString)")
        print("params--->\(params)")
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        URLCache.shared.removeCachedResponse(for: urlRequest)
        let headers: HTTPHeaders = [:]
        AF.request(urlString, method: .post,
                   parameters: params ,
                   encoding: URLEncoding.httpBody,
                   headers: headers).validate()
            .response { response in
                var returndata = Data()
                switch response.result {
                case .success:
                    print(response)
                    if let data = response.data {
                        returndata = data
                        completionHandler(returndata, true)
                    }
                case .failure:
                    completionHandler(returndata, false)
                }
            }
    }
}
