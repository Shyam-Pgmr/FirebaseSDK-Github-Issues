//
//  IssuesViewModel.swift
//  FirebaseSDK Issues
//
//  Created by Shyam Kumar on 28/06/19.
//  Copyright © 2019 Shyam Kumar. All rights reserved.
//

import Foundation
import RxSwift

final class IssuesViewModel: BaseViewModel {
    
    let services: GithubService
    var issues = BehaviorSubject<[GithubIssue]>(value: [])
    let selectedItem = PublishSubject<IndexPath>()
    let navigationController: UINavigationController?
    
    init(services: GithubService = GithubService(), navigationController: UINavigationController?) {
        self.services = services
        self.navigationController = navigationController
        super.init()
        
        selectedItem
            .subscribe(onNext: { [weak self] (indexPath) in
                guard let issue = try? self?.issues.value()[indexPath.row], issue.comments > 0 else { return }
                self?.showCommentsScreen(issueId: issue.id)
            }).disposed(by: disposeBag)
    }
    
}

// MARK: - Helper
extension IssuesViewModel {
    
    func showCommentsScreen(issueId: Int) {
        let viewModel = CommentsViewModel(services: services, issueId: issueId)
        let commentsController = CommentsViewController.instance()
        commentsController.viewModel = viewModel
        navigationController?.pushViewController(commentsController, animated: true)
    }
}

// MARK: - APIs
extension IssuesViewModel {
    
    func fetchIssues() {
        guard shouldFetchAndUpdateIssuesLocally else {
            // Local cache is available use it instead of hitting server
            let localIssues = CoreDataHelper.fetchIssues()
            issues.onNext(localIssues)
            return
        }
        isLoading.onNext(true)
        services.getIssues()
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe({ [unowned self] (event) in
                switch event {
                case .next(let issues):
                    self.issues.onNext(issues)
                    self.cacheLocally(issues: issues)
                case .error(let error):
                    self.showAlert.onNext(error.localizedDescription)
                default: break
                }
                self.isLoading.onNext(false)
            }).disposed(by: disposeBag)
    }
    
    private func cacheLocally(issues: [GithubIssue]) {
        CoreDataManager.deleteRecords(entity: IssueMO.self)
        CoreDataHelper.storeIssues(issues: issues)
        UserDefaults.lastUpdatedTime = Date()        
    }
}
