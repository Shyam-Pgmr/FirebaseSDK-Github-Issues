//
//  CommentsViewController.swift
//  FirebaseSDK Issues
//
//  Created by Shyam Kumar on 28/06/19.
//  Copyright © 2019 Shyam Kumar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CommentsViewController: UIViewController, Instantiable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIStackView!
    
    private let disposeBag = DisposeBag()
    var viewModel: CommentsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupUI()
        setupBinding()
        loadData()
    }
    
    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .never
        tableView.register(cellType: CommentsCell.self)
        tableView.tableFooterView = UIView()
    }
    
    private func setupBinding() {
        
        viewModel.isLoading
            .map{ !$0 }
            .asDriver(onErrorJustReturn: false)
            .drive(loadingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.comments.bind(to: tableView.rx.items(cellIdentifier: CommentsCell.Identifier, cellType: CommentsCell.self)) { (index, model, cell) in
            cell.comment = model
            }.disposed(by: disposeBag)
        

        viewModel.showAlert
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (message) in
                self?.showAlert(message: message)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.fetchComments()
    }
}
