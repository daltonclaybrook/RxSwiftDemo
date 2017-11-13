//
//  URLSession+Rx.swift
//  RxSwiftDemo
//
//  Created by Dalton Claybrook on 11/12/17.
//  Copyright © 2017 Dalton Claybrook. All rights reserved.
//

import Alamofire
import RxSwift

struct GitHub {
    private let baseURL = URL(string: "https://api.github.com")!

    func fetchRepos(with query: String) -> Single<DataResponse<Data>> {
        return Single.create { eventBlock in
            let url = self.baseURL.appendingPathComponent("search/repositories")
            let request = Alamofire.request(url, parameters: ["q": query])
                .responseData { response in
                    eventBlock(.success(response))
                }
                .validate(statusCode: 200..<300)
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
