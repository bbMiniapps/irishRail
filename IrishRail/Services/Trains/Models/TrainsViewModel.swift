//
//  TrainsViewModel.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation

struct TrainsViewModel {
    
    private let asyncOQ = CustomOperationQueue()
    
    func trainsFromTo(_ pF: () -> (String, String, String, TrainDirection),
                      completion: @escaping SCompletion<[TrainDataModel]>) {
        let (startStationDesc, endStationDesc, mainStation, direction) = pF()
        
        let block = BlockOperation {
            var isContainsZeroValue = false
            var iErrors = [InternalError]()
            var rTrains = [TrainInfo]()
            
            let concurrentQueue = DispatchQueue(label: "TrainsDispatchQueue", attributes: .concurrent)
            let group = DispatchGroup()
            
            let rtFilterF: SFilter<[TrainInfo]> = { f in
                typealias FunctionType = () -> [TrainInfo]
                
                guard let trains = (f as? FunctionType)?() else {
                    return []
                }
                
                let direct = direction.rawValue
                let messageFilter = mainStation
                let result = trains.filter { $0.direction == direct && $0.message.contains(messageFilter) }
                
                return result
            }
            
            group.enter()
            let smt = ServiceManager<TrainsService> { TrainsService() }
            smt.request(filter: rtFilterF) { result in
                concurrentQueue.async {
                    switch result {
                    case .success(let trains):
                        concurrentQueue.async(flags: .barrier) {
                            if trains.count == 0 {
                                isContainsZeroValue = true
                            } else {
                                rTrains.append(contentsOf: trains)
                            }
                            
                            group.leave()
                        }
                    case .failure(let error):
                        concurrentQueue.async(flags: .barrier) {
                            iErrors.append(error)
                            group.leave()
                        }
                    }
                }
            }
            
            group.wait()
            
            if iErrors.count > 0,
                let error = iErrors.first {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                
                return
            }
            
            if isContainsZeroValue {
                DispatchQueue.main.async {
                    completion(.success([]))
                }
                
                return
            }
            
            var trainsDataModels = [TrainDataModel]()
            
            let ctFilterF: SFilter<[TrainInfo]> = { f in
                typealias FunctionType = () -> [TrainInfo]
                
                guard let cTrains = (f as? FunctionType)?() else {
                    return []
                }
                
                let result = cTrains.filter { $0.locationFullName == startStationDesc || $0.locationFullName == endStationDesc }
                
                return result
            }
            
            rTrains.forEach { train in
                group.enter()
                let sm = ServiceManager<ConcreteTrainService> { ConcreteTrainService(pF: { train.trainCode }) }
                sm.request(filter: ctFilterF) { result in
                    concurrentQueue.async {
                        switch result {
                        case .success(let staionsTrain):
                            guard !staionsTrain.isEmpty,
                                let originTrainInfo = staionsTrain.first,
                                let destinationTrainInfo = staionsTrain.last else {
                                group.leave()
                                return
                            }
                            
                            let aspl = AdditionalServerParseLogic()
                            let trainDataModel = aspl.trainDataModel({ (originTrainInfo, destinationTrainInfo) })
                            
                            concurrentQueue.async(flags: .barrier) {
                                trainsDataModels.append(trainDataModel)
                                group.leave()
                            }
                        case .failure(let error):
                            concurrentQueue.async(flags: .barrier) {
                                iErrors.append(error)
                                group.leave()
                            }
                        }
                    }
                }
            }
            
            group.wait()
            
            if iErrors.count > 0,
                let error = iErrors.first {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                
                return
            }
            
            trainsDataModels = trainsDataModels.sorted(by: {
                guard let oExpArrival = $0.originExpArrival,
                    let nOExpArrival = $1.originExpArrival else {
                    return false
                }
                
                return oExpArrival.compare(nOExpArrival) == .orderedDescending
            })
            DispatchQueue.main.async {
                completion(.success(trainsDataModels))
            }
        }
        asyncOQ.addBlock(block)
    }
    
}
