//
//  Repo.swift
//  RxSwiftDemo
//
//  Created by Dalton Claybrook on 11/12/17.
//  Copyright © 2017 Dalton Claybrook. All rights reserved.
//

import Foundation

struct ReposResponse: Codable {
    let items: [Repo]
}

struct Repo: Codable {
    let name: String
    let url: URL
}
