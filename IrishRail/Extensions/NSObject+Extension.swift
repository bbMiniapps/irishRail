//
//  NSObject+Extension.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation

extension NSObject {
    
    class var nameOfClass: String {
        guard let name = NSStringFromClass(self).components(separatedBy: ".").last else {
            return ""
        }
        
        return name
    }
    
}
