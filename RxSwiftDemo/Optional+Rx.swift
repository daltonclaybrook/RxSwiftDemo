//
//  Optional+Rx.swift
//  RxSwiftDemo
//
//  Created by Dalton Claybrook on 11/12/17.
//  Copyright © 2017 Dalton Claybrook. All rights reserved.
//

import RxSwift

protocol OptionalType {
    associatedtype Wrapped
    var wrapped: Wrapped? { get }
}

extension Optional: OptionalType {
    var wrapped: Wrapped? {
        return self
    }
}

extension ObservableType where E: OptionalType {
    func flatMapUnwrap() -> Observable<E.Wrapped> {
        return flatMap { value in
            return value.wrapped.flatMap { Observable.just($0) } ?? .never()
        }
    }
}
