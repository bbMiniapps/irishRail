//
//  UITableViewCell+Extension.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    class func nibName() -> String {
        return self.nameOfClass
    }

    class func cellIdentifier() -> String {
        return self.nibName()
    }
    
}
