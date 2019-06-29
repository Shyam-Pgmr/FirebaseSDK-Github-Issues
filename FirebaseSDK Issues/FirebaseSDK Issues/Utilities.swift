//
//  Extensions.swift
//  FirebaseSDK Issues
//
//  Created by Shyam Kumar on 28/06/19.
//  Copyright © 2019 Shyam Kumar. All rights reserved.
//

import UIKit


extension UITableView {
    
    func register<C: UITableViewCell>(cellType: C.Type) {
        register(UINib(nibName: String(describing: cellType), bundle: nil), forCellReuseIdentifier: String(describing: cellType))
    }
}

protocol Instantiable: class { }

extension Instantiable where Self : UIViewController {
    static func instance() -> Self {
       return UIStoryboard.main.instantiateViewController(withIdentifier: String(describing: Self.self)) as! Self
    }
}

extension UIStoryboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
}
