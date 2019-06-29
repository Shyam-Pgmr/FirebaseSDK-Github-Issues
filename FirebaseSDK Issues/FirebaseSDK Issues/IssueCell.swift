//
//  IssueCell.swift
//  FirebaseSDK Issues
//
//  Created by Shyam Kumar on 28/06/19.
//  Copyright © 2019 Shyam Kumar. All rights reserved.
//

import UIKit

class IssueCell: UITableViewCell {

    static let Identifier = "IssueCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var issue: GithubIssue! {
        didSet {
            titleLabel.text = issue.title
            bodyLabel.text = issue.body
            accessoryType = issue.comments > 0 ? .disclosureIndicator : .none
            selectionStyle = issue.comments > 0 ? .default : .none
        }
    }
    
}
