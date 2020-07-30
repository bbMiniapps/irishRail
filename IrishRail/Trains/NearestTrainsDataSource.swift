//
//  NearestTrainsDataSource.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation
import UIKit

final class NearestTrainsDataSource: NSObject {
    
    typealias CellParams = () -> (UITableView, IndexPath, TrainDataModel)
    
    private var data = [TrainDataModel]()
    fileprivate var cellGenerator = [String: (CellParams) -> UITableViewCell]()
    
    override init() {
        super.init()
        
        let trainCell: (CellParams) -> UITableViewCell = { pF in
            let (tableView, indexPath, model) = pF()
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TrainCell.cellIdentifier(),
                                                           for: indexPath) as? TrainCell else {
                                                            fatalError("+++ TrainCell not found")
            }
            
            cell.populate(model)
            return cell
        }
        
        cellGenerator[String(describing: TrainDataModel.self)] = trainCell
    }
    
}

extension NearestTrainsDataSource {
    
    func populate(_ dataSource: [TrainDataModel]) {
        data.append(contentsOf: dataSource)
    }
    
    func hasData() -> Bool {
        return data.count != 0
    }
    
    func resetDataSource() {
        data.removeAll()
    }
    
}

extension NearestTrainsDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = data[indexPath.row]
        let key = classNameDescription({ model }) ?? ""
        let cell = cellGenerator[key]?({ (tableView, indexPath, model) })
        
        return cell ?? UITableViewCell()
    }
    
}
