//
//  Constant.swift
//  USHeadlines
//
//  Created by siva chitran p on 11/08/22.
//

import Foundation
import SDWebImage

class Constant: NSObject, SDWebImageManagerDelegate {
    
    static let sharedInstance = Constant()
    
    // Check Null Value
    
    static func checkNull(_ val : Any?) -> String { return val is NSNull || val == nil ? "" : String(describing: val!) }
    
    // Load Image form URL
    
    func loadImageFromUrl(urlString: String, placeholderImage: String = "", imageView: UIImageView) {
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: imageView.bounds.width, height: imageView.bounds.height), scaleMode: .fill)
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_imageTransition = SDWebImageTransition.fade
        imageView.sd_setImage(with: URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: "placeHolder"), context: [.imageTransformer: transformer])
    }
    
    //Get SafeArea Height
    
    func getSafeAreaHeight(type:ShadowLocation)->CGFloat{
        var bottomSafeAreaHeight: CGFloat = 0
        var topSafeAreaHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
            topSafeAreaHeight = safeFrame.minY
            return type == .top ? topSafeAreaHeight:bottomSafeAreaHeight
        }
        return 0
    }
    
     func getCurrentShortDate() -> String {
         let todaysDate = Date()
         let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
         let DateInFormat = dateFormatter.string(from: todaysDate)
        return DateInFormat
    }
}

enum ShadowLocation: String {
    case bottom
    case top
}
