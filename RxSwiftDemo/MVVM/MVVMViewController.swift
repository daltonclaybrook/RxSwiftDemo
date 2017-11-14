//
//  MVVMViewController.swift
//  RxSwiftDemo
//
//  Created by Dalton Claybrook on 11/13/17.
//  Copyright © 2017 Dalton Claybrook. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class MVVMViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    private let loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingView)
        
        let viewModel = SearchViewModel(disposeBag: disposeBag)
        bindQuery(to: viewModel)
        bindTableView(to: viewModel)
        bindLoadingView(to: viewModel)
    }
    
    // MARK: Private
    
    private func bindQuery(to viewModel: SearchViewModel) {
        searchBar
            .rx
            .text
            .asObservable()
            .flatMapUnwrap()
            .bind(to: viewModel.queryObserver)
            .disposed(by: disposeBag)
    }
    
    private func bindTableView(to viewModel: SearchViewModel) {
        viewModel
            .repos
            .bind(to: tableView.rx.items(cellIdentifier: RepoCell.reuseId, cellType: RepoCell.self)) { (_, repo, cell) in
                cell.configure(with: repo)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindLoadingView(to viewModel: SearchViewModel) {
        viewModel
            .isLoading
            .bind(to: loadingView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
