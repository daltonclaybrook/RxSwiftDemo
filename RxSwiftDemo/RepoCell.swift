//
//  RepoCell.swift
//  RxSwiftDemo
//
//  Created by Dalton Claybrook on 11/12/17.
//  Copyright © 2017 Dalton Claybrook. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {
    static var reuseId: String {
        return "RepoCell"
    }
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var urlLabel: UILabel!
    
    func configure(with repo: Repo) {
        self.nameLabel.text = repo.name
        self.urlLabel.text = repo.url.absoluteString
    }
}
