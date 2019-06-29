//
//  CoreDataHelper.swift
//  FirebaseSDK Issues
//
//  Created by Shyam Kumar on 29/06/19.
//  Copyright © 2019 Shyam Kumar. All rights reserved.
//

import Foundation

final class CoreDataHelper {
    
    private static func insertOrUpdate(_ issue: GithubIssue) {
        let predicate = NSPredicate(format: "id == %d", issue.id)
        let issueMO = CoreDataManager.insertOrUpdate(entity: IssueMO.self, predicate: predicate)
        issueMO.id = Int64(issue.id)
        issueMO.title = issue.title
        issueMO.body = issue.body
        issueMO.comments = Int64(issue.comments)
        issueMO.updatedAt = issue.updatedAt
        CoreDataManager.savePrivateContext()
    }
    
}

extension CoreDataHelper {
    
    static func storeIssues(issues:[GithubIssue]) {
        issues.forEach { insertOrUpdate($0) }
    }
    
    static func fetchIssues() -> [GithubIssue] {
        let sortUpdatedTime = NSSortDescriptor(key: "updatedAt", ascending: false)
        guard let result = CoreDataManager.fetchRecords(entity: IssueMO.self,sortBy: [sortUpdatedTime]) else {
            return []
        }
        let issues = result.map { GithubIssue($0) }
        return issues
    }
}

extension GithubIssue {
    
    init(_ issueMO: IssueMO) {
        id = Int(issueMO.id)
        title = issueMO.title ?? ""
        body = issueMO.body ?? ""
        comments = Int(issueMO.comments)
        updatedAt = issueMO.updatedAt ?? ""
    }
}
