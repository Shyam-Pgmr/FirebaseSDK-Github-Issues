//
//  CommentsViewModel.swift
//  FirebaseSDK Issues
//
//  Created by Shyam Kumar on 28/06/19.
//  Copyright © 2019 Shyam Kumar. All rights reserved.
//

import Foundation

import Foundation
import RxSwift

final class CommentsViewModel: BaseViewModel {
    
    let services: GithubService
    var comments = BehaviorSubject<[IssueComment]>(value: [])
    let issueId: Int
    
    init(services: GithubService = GithubService(), issueId: Int) {
        self.services = services
        self.issueId = issueId
        super.init()
    }
    
}

// MARK: - APIs
extension CommentsViewModel {
    
    func fetchComments() {        
        isLoading.onNext(true)
        services.getComments(id: issueId)
            .asObservable()
            .subscribe({ [weak self] (event) in
                switch event {
                case .next(let comments):
                    self?.comments.onNext(comments)
                case .error(let error):
                    self?.showAlert.onNext(error.localizedDescription)
                default: break
                }
                self?.isLoading.onNext(false)
            }).disposed(by: disposeBag)
    }
}
