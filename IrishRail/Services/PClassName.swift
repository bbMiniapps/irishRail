//
//  PClassName.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation

protocol PClassName {
    func className() -> String
}

extension PClassName {
    func className() -> String {
        return String(describing: type(of: self))
    }
}

func classNameDescription<T>(_ classF: () -> T?) -> String? where T: PClassName {
    guard let co = classF() else {
        return nil
    }
    
    return co.className()
}
