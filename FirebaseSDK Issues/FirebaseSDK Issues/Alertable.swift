//
//  AlertableViewController.swift
//  FirebaseSDK Issues
//
//  Created by Shyam Kumar on 28/06/19.
//  Copyright © 2019 Shyam Kumar. All rights reserved.
//

import UIKit

protocol Alertable {
    
    func showAlert(title: String?, message: String, actionHandler:((UIAlertAction)->Void)?)
    
}

extension UIViewController: Alertable {
    
    func showAlert(title: String? = nil, message: String, actionHandler:((UIAlertAction)->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: actionHandler)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
