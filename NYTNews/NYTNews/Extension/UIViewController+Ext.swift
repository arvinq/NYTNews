//
//  UIViewController+Ext.swift
//  NYTNews
//
//  Created by Arvin on 30/9/21.
//

import UIKit
import SafariServices

extension UIViewController {
    /**
     * Show alert using the passed title and message.
     *
     * - Parameters:
     *      - title: Title of the alert
     *      - message: Information message showing the reason for the alert
     *      - buttonTitle: Title of the button to dismiss the alert
     */
    func presentAlert(withTitle title: String, andMessage message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: buttonTitle, style: .cancel)
            
            alertController.addAction(alertAction)
            self.present(alertController, animated: true)
        }
    }
    
    func presentSafariViewController(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredBarTintColor = .white
        present(safariViewController, animated: true)
    }
}
