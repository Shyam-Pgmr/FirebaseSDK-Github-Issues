//
//  IssueComment.swift
//  FirebaseSDK Issues
//
//  Created by Shyam Kumar on 28/06/19.
//  Copyright © 2019 Shyam Kumar. All rights reserved.
//

import Foundation


struct IssueComment: Codable {
    let id: Int
    let user: User
    let body: String

    struct User: Codable {
        let id: Int
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case name = "login"
        }
    }
}
