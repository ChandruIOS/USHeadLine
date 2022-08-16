//
//  LoaderHandler.swift
//  USHeadlines
//
//  Created by siva chitran p on 11/08/22.
//

import NVActivityIndicatorView
import UIKit

extension UIViewController: NVActivityIndicatorViewable  {
    
    func showToast(message : String, font: UIFont = UIFont(name: "HelveticaNeue-Bold", size: 13) ?? UIFont.systemFont(ofSize: 13)) {
        
        let tag = 61194
        let window = UIApplication.keyWindow!
        
        let toastLabel = UILabel()
        toastLabel.font = font
        toastLabel.text = message
        toastLabel.backgroundColor = UIColor.clear
        toastLabel.textColor = UIColor.white
        toastLabel.numberOfLines = 0
        toastLabel.textAlignment = .center;
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.tag = tag
        
        let maxSize = CGSize(width: (window.frame.size.width - 150), height: 500)
        let size = toastLabel.sizeThatFits(maxSize)
        toastLabel.frame = CGRect(origin: CGPoint(x: window.frame.size.width/2 - 75, y: window.frame.size.height-100), size: size)
        toastLabel.frame.origin.y = window.frame.size.height-100
        toastLabel.frame.origin.x = (window.frame.size.width/2) - (toastLabel.frame.size.width/2)
        
        
        let BGView = UIView()
        BGView.frame = CGRect.init(x: (toastLabel.frame.minX - 10), y: (toastLabel.frame.minY - 10), width: (toastLabel.frame.width + 20), height: (toastLabel.frame.height + 20))
        BGView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        BGView.layer.cornerRadius = 10;
        BGView.tag = tag
        
        for view in window.subviews {
            if view.tag == tag {
                view.removeFromSuperview()
            }
        }
        
        window.addSubview(BGView)
        window.addSubview(toastLabel)
        
        BGView.FadeAnimateView(alpha: 0, duration: 0.5, delay: 1) { (status) in
            BGView.removeFromSuperview()
        }
        toastLabel.FadeAnimateView(alpha: 0, duration: 0.5, delay: 1) { (status) in
            toastLabel.removeFromSuperview()
        }
    }

    func showloader(_ show : Bool) {
        
        let size = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_COLOR = UIColor.white
        if show {
            self.startAnimating(size, message: "", type: .ballSpinFadeLoader, fadeInAnimation: nil)
        }else{
            self.stopAnimating(nil)
        }
    }
    
}

extension UIView {
    func FadeAnimateView(alpha:CGFloat,duration:TimeInterval,delay:TimeInterval, completion: @escaping (_ status:Bool) -> ()) {
        UIView.animate(withDuration: duration, delay: delay, options: .transitionFlipFromTop, animations: {
            self.alpha = alpha
        }, completion: {(isCompleted) in
            completion(true)
        })
    }
}


