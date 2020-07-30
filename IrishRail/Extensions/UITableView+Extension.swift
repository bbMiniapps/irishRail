//
//  UITableView+Extension.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerTableViewCellNibs(_ cellsPF: () -> [AnyClass]) {
        let cells = cellsPF()
        
        for item in cells where item is UITableViewCell.Type {
            self.register(UINib(nibName: "\(item)", bundle: nil), forCellReuseIdentifier: "\(item)")
        }
    }
    
}
