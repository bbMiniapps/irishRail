//
//  ServiceLogic.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation

typealias SFilter<A> = (Any) -> A?
typealias SCompletion<A> = (Result<A, InternalError>) -> Void
typealias SRequest<A> = (_ filter: SFilter<A>?, _ completion: SCompletion<A>?) -> Void

protocol PService {
    associatedtype A
    var request: SRequest<A>? { get }
}

struct ServiceManager<T: PService> {
    
    let service: () -> T?
    
    func request<A>(filter: SFilter<A>? = nil, completion: SCompletion<A>? = nil)
        where T.A == A {
        guard let req = service()?.request else {
            let error = InternalError(message: "Invalid request",
                                      errorType: .app)
            completion?(.failure(error))
            return
        }

        req(filter, completion)
    }
    
}
