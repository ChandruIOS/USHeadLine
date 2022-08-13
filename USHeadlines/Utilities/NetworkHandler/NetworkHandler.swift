//
//  NetworkHandler.swift
//  USHeadlines
//
//  Created by siva chitran p on 11/08/22.
//

import UIKit
import Reachability

class NetworkHandler: NSObject {
    static let instance = NetworkHandler()
    let reachability = try! Reachability()
    var presented = Bool()
    var isReachble = false
    
    func initiateRecahbility() {
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                self.isReachble = true
            } else {
                self.isReachble = true
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.isReachble = false
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            self.isReachble = true
            print("Reachable via WiFi")
            NotificationCenter.default.post(name: .reachabilityChanged, object: self)
            
        case .cellular:
            self.isReachble = true
            print("Reachable via Cellular")
            NotificationCenter.default.post(name: .reachabilityChanged, object: self)
            
        case .unavailable:
            self.isReachble = false
            print("Network not reachable")
            self.showNetworkError(self.isReachble)
        }
        
        if presented == true {
            self.showNetworkError(self.isReachble)
        }
    }
    
    
    private func showNetworkError(_ status : Bool) {
        
        let tag = 180294
        DispatchQueue.main.async {
            self.presented = true
            let window = UIApplication.keyWindow!
            let errorLabel = UILabel()
            
            let topSafeArea = Constant.sharedInstance.getSafeAreaHeight(type: .top)
            let BG_Color = status ? UIColor.systemGreen : UIColor.red
            
            errorLabel.frame = CGRect(x: ((window.frame.width/2) - 100) , y: topSafeArea , width: 200, height: 40)
            errorLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0) ?? UIFont.systemFont(ofSize: 15)
            errorLabel.textColor = .white
            errorLabel.backgroundColor = BG_Color
            errorLabel.layer.cornerRadius = 8
            errorLabel.clipsToBounds = true
            errorLabel.textAlignment = .center
            errorLabel.text = !status ? "You are Offline.": "You are Online."
            errorLabel.tag = tag
            
            for view in window.subviews {
                if view.tag == tag {
                    view.removeFromSuperview()
                }
            }
            window.addSubview(errorLabel)
            
            if status {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    for view in window.subviews {
                        if view.tag == tag {
                            view.removeFromSuperview()
                        }
                    }
                }
            }
            
        }
    }
    
}


