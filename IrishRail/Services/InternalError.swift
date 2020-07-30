//
//  InternalError.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation

enum ErrorType {
    
    case app
    case service
    
}

struct InternalError: LocalizedError {
    
    let message: String
    let debugMessage: String
    let name: String
    let errorType: ErrorType
    let code: Int
    
    init(message: String?,
         errorType: ErrorType = .service,
         name: String? = "",
         debugMessage: String? = "",
         code: Int = -1) {
        self.message = message ?? ""
        self.errorType = errorType
        self.debugMessage = debugMessage ?? ""
        self.name = name ?? ""
        self.code = code
    }
    
}
