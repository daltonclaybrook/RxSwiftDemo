//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by Dalton Claybrook on 11/12/17.
//  Copyright © 2017 Dalton Claybrook. All rights reserved.
//

import Alamofire
import RxCocoa
import RxSwift
import UIKit

class SearchViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    private let loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
    
    private let isLoading = Variable(false)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingView)
        bindSearchBarToTableView()
        bindLoadingView()
    }
    
    // MARK: Binding
    
    private func bindSearchBarToTableView() {
        let isLoading = self.isLoading
        searchBar
            .rx
            .text
            .asObservable()
            .flatMapUnwrap()
            .do(onNext: { _ in isLoading.value = true })
            .debounce(1.0, scheduler: MainScheduler.instance)
            .flatMap(self.fetchRepos(with:))
            .do(onNext: { _ in isLoading.value = false })
            .bind(to: tableView.rx.items(cellIdentifier: RepoCell.reuseId, cellType: RepoCell.self)) { (_, repo, cell) in
                cell.configure(with: repo)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindLoadingView() {
        isLoading
            .asObservable()
            .bind(to: loadingView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    // MARK: Data
    
    private func fetchRepos(with query: String) -> Driver<[Repo]> {
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
            .asDriver(onErrorJustReturn: [])
    }
}
