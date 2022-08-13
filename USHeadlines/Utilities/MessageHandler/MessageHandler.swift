//
//  MessageHandler.swift
//  USHeadlines
//
//  Created by siva chitran p on 11/08/22.
//

import UIKit
import SwiftMessages

class MessageHandler: NSObject {
    
    static let sharedinstance = MessageHandler()
    
    func showSuccessMessageWithTxt(msg:String){
        guard msg.count>0 else {
            return
        }
        let convertedMsg = msg
        let success = MessageView.viewFromNib(layout: .messageView)
        success.configureTheme(.success)
        success.backgroundView.backgroundColor = UIColor.green
        success.configureDropShadow()
        success.configureContent(title: "", body: convertedMsg)
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        SwiftMessages.show(config: successConfig, view: success)
    }
    
    func showErrorMessageWithTxt(msg:String){
        guard msg.count>0 else {
            return
        }
        let convertedMsg = msg
        let error = MessageView.viewFromNib(layout: .messageView)
        error.configureTheme(.error)
        error.backgroundView.backgroundColor = UIColor.red
        error.configureDropShadow()
        error.configureContent(title: "", body: convertedMsg)
        error.button?.isHidden = true
        var errorConfig = SwiftMessages.defaultConfig
        errorConfig.presentationStyle = .top
        errorConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        SwiftMessages.show(config: errorConfig, view: error)
    }
    
}


