//
//  UserDefaultsHelper.swift
//  FirebaseSDK Issues
//
//  Created by Shyam Kumar on 29/06/19.
//  Copyright © 2019 Shyam Kumar. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static var lastUpdatedTime: Date? {
        set {
            standard.set(newValue, forKey: "LastUpdatedTime")
            standard.synchronize()
        }
        
        get {
            return standard.object(forKey: "LastUpdatedTime") as? Date
        }
    }
}
