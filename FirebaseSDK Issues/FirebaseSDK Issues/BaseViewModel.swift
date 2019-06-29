//
//  BaseViewModel.swift
//  FirebaseSDK Issues
//
//  Created by Shyam Kumar on 28/06/19.
//  Copyright © 2019 Shyam Kumar. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel {
    let isLoading = BehaviorSubject<Bool>(value: false)
    let disposeBag = DisposeBag()
    let showAlert = PublishSubject<String>()
}
