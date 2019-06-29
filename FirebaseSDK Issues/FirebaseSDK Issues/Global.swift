//
//  Constants.swift
//  FirebaseSDK Issues
//
//  Created by Shyam Kumar on 27/06/19.
//  Copyright © 2019 Shyam Kumar. All rights reserved.
//

import Foundation

var shouldFetchAndUpdateIssuesLocally: Bool {
    guard let last = UserDefaults.lastUpdatedTime else {
        return true
    }
    let timeInterval = Date().timeIntervalSince(last)
    return timeInterval > (24 * 60 * 60 /* 24 hours */)
}
