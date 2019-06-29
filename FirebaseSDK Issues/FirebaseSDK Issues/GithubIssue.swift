//
//  GithubIssue.swift
//  FirebaseSDK Issues
//
//  Created by Shyam Kumar on 27/06/19.
//  Copyright © 2019 Shyam Kumar. All rights reserved.
//

import Foundation

struct GithubIssue: Codable {
    let id: Int
    let title: String
    let body: String
    let comments: Int
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "number"
        case updatedAt = "updated_at"
        case title, body, comments
    }
}
