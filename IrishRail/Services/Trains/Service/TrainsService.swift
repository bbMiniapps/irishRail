//
//  TrainsService.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation

struct TrainsService: PService {
    
    typealias A = [TrainInfo]
    
    let request: SRequest<A>?
    
    init() {
        request = { filter, completion in
            let stringURL = "\(ServerConstants.serverBaseURL)/getCurrentTrainsXML"
            
            guard let url = URL(string: stringURL) else {
                let err = InternalError(message: "Incorrect server address!",
                                        errorType: .app)
                completion?(.failure(err))
                
                return
            }
            
            let parserF: (Data) -> A = { data in
                let stiParser = TrainInfoParser()
                let parseData = stiParser.parse(data)
                let result = filter?({ parseData }) ?? parseData
                
                return result
            }
            
            let resource = Resource<A>(url: url, pF: parserF)
            URLSession.shared.load(resource) { result in
                completion?(result)
            }
        }
    }
    
}
