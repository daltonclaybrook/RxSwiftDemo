//
//  Model+Rx.swift
//  RxSwiftDemo
//
//  Created by Dalton Claybrook on 11/12/17.
//  Copyright © 2017 Dalton Claybrook. All rights reserved.
//

import RxSwift

extension ObservableType where E == Data {
    public func mapModel<T: Decodable>(model: T.Type) -> Observable<T> {
        return flatMap { data -> Observable<T> in
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(model, from: data)
            return .just(decoded)
        }
    }
}
