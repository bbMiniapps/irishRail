//
//  LoadingState.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation

enum LoadingState {
    
    case loading
    case populated(data: [Any])
    case empty
    case error(InternalError)
    case clear
    
}

extension LoadingState: Equatable {
    
    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.populated(_), .populated(_)):
            return true
        case (.empty, .empty):
            return true
        case (.error, .error):
            return true
        case (.clear, .clear):
            return true
        default:
            return false
        }
    }
    
}
