//
//  CustomOperationQueue.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation

struct CustomOperationQueue {
    
    private let asyncCustomOperationQueue = OperationQueue()
    
    init() {
        asyncCustomOperationQueue.name = "com.bh.MoreAsyncOperationQueue"
        asyncCustomOperationQueue.maxConcurrentOperationCount = 4
    }
    
    func addBlocks(_ operations: [BlockOperation], _ waitUntilFinished: Bool) {
        asyncCustomOperationQueue.addOperations(operations, waitUntilFinished: false)
    }
    
    func addBlock(_ operation: BlockOperation) {
        asyncCustomOperationQueue.addOperation(operation)
    }
    
}
