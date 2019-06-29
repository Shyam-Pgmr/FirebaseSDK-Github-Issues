//
//  CommentsCell.swift
//  FirebaseSDK Issues
//
//  Created by Shyam Kumar on 28/06/19.
//  Copyright © 2019 Shyam Kumar. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {
    
    static let Identifier = "CommentsCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var comment: IssueComment! {
        didSet {
            titleLabel.text = comment.user.name
            bodyLabel.text = comment.body
        }
    }
    
}
