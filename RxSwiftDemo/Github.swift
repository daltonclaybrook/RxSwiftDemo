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

    func fetchRepos(with query: String) -> Observable<DataResponse<Data>> {
        return Observable.create { subscriber in
            let url = self.baseURL.appendingPathComponent("search/repositories")
            let request = Alamofire.request(url, parameters: ["q": query])
                .validate(statusCode: 200..<300)
                .responseData { response in
                    subscriber.onNext(response)
                    subscriber.onCompleted()
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
