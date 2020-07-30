//
//  AdditionalServerParseLogic.swift
//  IrishRail
//
//  Created by Boris Hristov on 30.07.20.
//  Copyright © 2020 bh. All rights reserved.
//

import Foundation

struct AdditionalServerParseLogic {
    typealias ResultF = (String) -> Void
    
    func elementF(_ eName: String,
                  _ eXMLName: String,
                  _ elementF: ResultF?) -> ResultF? {
        guard eName == eXMLName else {
            return nil
        }
        
        return elementF
    }
    
    func trainDataModel(_ pF: () -> (TrainInfo, TrainInfo)) -> TrainDataModel {
        let (originTrainInfo, destinationTrainInfo) = pF()
        
        let asdl = AdditionalServerDataLogic()
        let valAfterDot = "000Z"
        
        let oExpArrival = asdl.dateBy(originTrainInfo.trainDate, originTrainInfo.expArrival, valAfterDot)
        let oSchArrival = asdl.dateBy(originTrainInfo.trainDate, originTrainInfo.schArrival, valAfterDot)
        let oExpDeparture = asdl.dateBy(originTrainInfo.trainDate, originTrainInfo.expDeparture, valAfterDot)
        let oSchDeparture = asdl.dateBy(originTrainInfo.trainDate, originTrainInfo.schDeparture, valAfterDot)
        var oArrival: Date?
        if let arrival = originTrainInfo.arrival {
            oArrival = asdl.dateBy(originTrainInfo.trainDate, arrival, valAfterDot)
        }
        var oDeparture: Date?
        if let departure = originTrainInfo.departure {
            oDeparture = asdl.dateBy(originTrainInfo.trainDate, departure, valAfterDot)
        }
        
        let dExpArrival = asdl.dateBy(destinationTrainInfo.trainDate, destinationTrainInfo.expArrival, valAfterDot)
        let dSchArrival = asdl.dateBy(destinationTrainInfo.trainDate, destinationTrainInfo.schArrival, valAfterDot)
        let dExpDeparture = asdl.dateBy(destinationTrainInfo.trainDate, destinationTrainInfo.expDeparture, valAfterDot)
        let dSchDeparture = asdl.dateBy(destinationTrainInfo.trainDate, destinationTrainInfo.schDeparture, valAfterDot)
        
        return TrainDataModel(trainCode: originTrainInfo.trainCode,
                              originStationDesc: originTrainInfo.locationFullName,
                              originExpArrival: oExpArrival,
                              originSchArrival: oSchArrival,
                              originExpDeparture: oExpDeparture,
                              originSchDeparture: oSchDeparture,
                              originArrival: oArrival,
                              originDeparture: oDeparture,
                              destinationStationDesc: destinationTrainInfo.locationFullName,
                              destinationExpArrival: dExpArrival,
                              destinationSchArrival: dSchArrival,
                              destinationExpDeparture: dExpDeparture,
                              destinationSchDeparture: dSchDeparture)
    }
    
}
