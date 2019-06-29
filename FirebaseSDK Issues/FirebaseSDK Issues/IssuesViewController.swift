//
//  IssuesViewController.swift
//  FirebaseSDK Issues
//
//  Created by Shyam Kumar on 27/06/19.
//  Copyright © 2019 Shyam Kumar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class IssuesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIStackView!

    private let disposeBag = DisposeBag()
    var viewModel: IssuesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        viewModel = IssuesViewModel(navigationController: self.navigationController)
        setupUI()
        setupBinding()
        loadData()
    }
    
    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .always
        tableView.register(cellType: IssueCell.self)
        tableView.tableFooterView = UIView()
    }
    
    private func setupBinding() {

        viewModel.isLoading
            .map{ !$0 }
            .asDriver(onErrorJustReturn: false)
            .drive(loadingView.rx.isHidden)
        .disposed(by: disposeBag)
        
        viewModel.issues.bind(to: tableView.rx.items(cellIdentifier: IssueCell.Identifier, cellType: IssueCell.self)) { (index, model, cell) in
                cell.issue = model
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .do(onNext: { self.tableView.deselectRow(at: $0, animated: true) })
            .bind(to: viewModel.selectedItem)
            .disposed(by: disposeBag)

        viewModel.showAlert
            .subscribe(onNext: { [weak self] (message) in
                self?.showAlert(message: message)
            })
        .disposed(by: disposeBag)
    }

    private func loadData() {
        viewModel.fetchIssues()
    }
}

