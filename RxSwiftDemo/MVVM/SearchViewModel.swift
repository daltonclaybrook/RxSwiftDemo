//
//  SearchViewModel.swift
//  RxSwiftDemo
//
//  Created by Dalton Claybrook on 11/13/17.
//  Copyright © 2017 Dalton Claybrook. All rights reserved.
//

import Foundation
import RxSwift

struct SearchViewModel {
    var isLoading: Observable<Bool> {
        return isLoadingVariable.asObservable()
    }
    var repos: Observable<[Repo]> {
        return reposVariable.asObservable()
    }
    var queryObserver: AnyObserver<String> {
        return querySubject.asObserver()
    }
    
    private let isLoadingVariable = Variable(false)
    private let reposVariable = Variable<[Repo]>([])
    private let querySubject = PublishSubject<String>()
    private let disposeBag: DisposeBag
    
    init(disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
        bindObservables()
    }
    
    // MARK: Private
    
    private func bindObservables() {
        querySubject
            .asObservable()
            .do(onNext: { _ in self.isLoadingVariable.value = true })
            .debounce(1.0, scheduler: MainScheduler.instance)
            .flatMap(self.fetchRepos(with:))
            .do(onNext: { _ in self.isLoadingVariable.value = false })
            .bind(to: reposVariable)
            .disposed(by: disposeBag)
    }
    
    private func fetchRepos(with query: String) -> Observable<[Repo]> {
        guard !query.isEmpty else {
            return .just([])
        }
        
        return GitHub()
            .fetchRepos(with: query)
            .asObservable()
            .map { $0.data }
            .flatMapUnwrap()
            .mapModel(model: ReposResponse.self)
            .map { $0.items }
            .catchErrorJustReturn([])
    }
}
