//
//  URLSession+Extension.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation

extension URLSession {
    func load<A>(_ r: Resource<A>, callback: @escaping (Result<A, InternalError>) -> ()) {
        dataTask(with: r.url) { data, response, err in
            
            if let e = err {
                let iErr = InternalError(message: e.localizedDescription,
                                         code: (response as? HTTPURLResponse)?.statusCode ?? -1)
                callback(.failure(iErr))
                
                return
            }
            
            guard let d = data else {
                let iErr = InternalError(message: "No data found!")
                callback(.failure(iErr))
                
                return
            }
            
            callback(.success(r.parse(d)))
        }.resume()
    }
}

struct Resource<A> {
    let url: URL
    let parse: (Data) -> A
}

extension Resource {

    init(url: URL, pF: @escaping (Data) -> A) {
        self.url = url
        parse = pF
//        parse = { data in
//            nil
//        }
    }

}
